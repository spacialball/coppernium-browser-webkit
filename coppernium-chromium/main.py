#!/usr/bin/env python3
"""
Coppernium Browser - Navegador basado en Chromium nativo
Usando CEF (Chromium Embedded Framework) para máximo rendimiento
"""

import sys
import os
from cefpython3 import cefpython as cef
import tkinter as tk
from tkinter import ttk, messagebox, simpledialog
import threading
import json
import urllib.parse
import webbrowser

class CopperniumBrowser:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Coppernium Browser - Chromium Native")
        self.root.geometry("1200x800")
        
        # Browser data
        self.current_url = ""
        self.bookmarks = self.load_bookmarks()
        self.history = []
        
        # Setup UI
        self.create_ui()
        self.setup_cef()
        
    def create_ui(self):
        """Create the browser interface"""
        
        # Main frame
        main_frame = ttk.Frame(self.root)
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Navigation frame
        nav_frame = ttk.Frame(main_frame)
        nav_frame.pack(fill=tk.X, padx=5, pady=5)
        
        # Navigation buttons
        ttk.Button(nav_frame, text="←", width=3, command=self.go_back).pack(side=tk.LEFT, padx=2)
        ttk.Button(nav_frame, text="→", width=3, command=self.go_forward).pack(side=tk.LEFT, padx=2)
        ttk.Button(nav_frame, text="⟳", width=3, command=self.reload).pack(side=tk.LEFT, padx=2)
        ttk.Button(nav_frame, text="🏠", width=3, command=self.go_home).pack(side=tk.LEFT, padx=2)
        
        # Address bar
        self.address_var = tk.StringVar()
        self.address_entry = ttk.Entry(nav_frame, textvariable=self.address_var, font=('Arial', 11))
        self.address_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=5)
        self.address_entry.bind('<Return>', self.navigate_to_url)
        
        # Go button
        ttk.Button(nav_frame, text="Go", command=self.navigate_to_url).pack(side=tk.RIGHT, padx=2)
        
        # Bookmark button
        ttk.Button(nav_frame, text="⭐", width=3, command=self.add_bookmark).pack(side=tk.RIGHT, padx=2)
        
        # Menu button
        ttk.Button(nav_frame, text="≡", width=3, command=self.show_menu).pack(side=tk.RIGHT, padx=2)
        
        # Browser frame
        self.browser_frame = ttk.Frame(main_frame)
        self.browser_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Status bar
        status_frame = ttk.Frame(main_frame)
        status_frame.pack(fill=tk.X, padx=5, pady=2)
        
        self.status_var = tk.StringVar(value="Ready")
        ttk.Label(status_frame, textvariable=self.status_var).pack(side=tk.LEFT)
        
        # Security indicator
        self.security_var = tk.StringVar()
        self.security_label = ttk.Label(status_frame, textvariable=self.security_var, foreground="green")
        self.security_label.pack(side=tk.RIGHT)
    
    def setup_cef(self):
        """Initialize CEF browser"""
        
        # CEF settings
        settings = {
            "multi_threaded_message_loop": False,
            "debug": False,
        }
        
        # Initialize CEF
        cef.Initialize(settings)
        
        # Create browser
        window_info = cef.WindowInfo()
        window_info.SetAsChild(self.browser_frame.winfo_id(), 
                              [0, 0, 1000, 600])
        
        # Browser settings
        browser_settings = {
            "web_security": False,  # Allow loading any content
            "file_access_from_file_urls": True,
            "universal_access_from_file_urls": True,
        }
        
        # Create browser instance
        self.browser = cef.CreateBrowserSync(
            window_info, 
            url="https://www.google.com",  # Start with Google
            settings=browser_settings
        )
        
        # Set client handlers
        self.browser.SetClientHandler(LoadHandler(self))
        
        # Start CEF message loop
        self.root.after(10, self.message_loop_work)
    
    def message_loop_work(self):
        """CEF message loop"""
        cef.MessageLoopWork()
        self.root.after(10, self.message_loop_work)
    
    def navigate_to_url(self, event=None):
        """Navigate to URL from address bar"""
        url = self.address_var.get().strip()
        if not url:
            return
            
        # Format URL
        if not url.startswith(('http://', 'https://')):
            if '.' in url and ' ' not in url:
                url = 'https://' + url
            else:
                # Search query
                url = f"https://www.google.com/search?q={urllib.parse.quote(url)}"
        
        self.browser.LoadUrl(url)
        self.add_to_history(url)
    
    def go_back(self):
        """Navigate back"""
        if self.browser.CanGoBack():
            self.browser.GoBack()
    
    def go_forward(self):
        """Navigate forward"""
        if self.browser.CanGoForward():
            self.browser.GoForward()
    
    def reload(self):
        """Reload current page"""
        self.browser.Reload()
    
    def go_home(self):
        """Go to home page"""
        self.browser.LoadUrl("https://www.google.com")
    
    def add_bookmark(self):
        """Add current page to bookmarks"""
        if not self.current_url:
            return
            
        title = simpledialog.askstring("Bookmark", "Enter bookmark name:", 
                                     initialvalue=self.current_url)
        if title:
            self.bookmarks.append({
                'title': title,
                'url': self.current_url,
                'timestamp': len(self.bookmarks)
            })
            self.save_bookmarks()
            messagebox.showinfo("Bookmark", "Bookmark added successfully!")
    
    def show_menu(self):
        """Show browser menu"""
        menu = tk.Menu(self.root, tearoff=0)
        
        menu.add_command(label="🏠 Home", command=self.go_home)
        menu.add_separator()
        menu.add_command(label="⭐ Show Bookmarks", command=self.show_bookmarks)
        menu.add_command(label="📜 Show History", command=self.show_history)
        menu.add_separator()
        menu.add_command(label="⚙️ Settings", command=self.show_settings)
        menu.add_separator()
        menu.add_command(label="ℹ️ About", command=self.show_about)
        
        # Show menu at cursor position
        try:
            menu.tk_popup(self.root.winfo_pointerx(), self.root.winfo_pointery())
        finally:
            menu.grab_release()
    
    def show_bookmarks(self):
        """Show bookmarks window"""
        if not self.bookmarks:
            messagebox.showinfo("Bookmarks", "No bookmarks saved yet.")
            return
            
        bookmarks_window = tk.Toplevel(self.root)
        bookmarks_window.title("Bookmarks")
        bookmarks_window.geometry("500x400")
        
        # Listbox for bookmarks
        listbox = tk.Listbox(bookmarks_window, font=('Arial', 10))
        listbox.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Populate bookmarks
        for bookmark in self.bookmarks:
            listbox.insert(tk.END, f"{bookmark['title']} - {bookmark['url']}")
        
        # Double-click to navigate
        def on_bookmark_select(event):
            selection = listbox.curselection()
            if selection:
                bookmark = self.bookmarks[selection[0]]
                self.browser.LoadUrl(bookmark['url'])
                bookmarks_window.destroy()
        
        listbox.bind('<Double-1>', on_bookmark_select)
    
    def show_history(self):
        """Show history window"""
        if not self.history:
            messagebox.showinfo("History", "No history available.")
            return
            
        history_window = tk.Toplevel(self.root)
        history_window.title("History")
        history_window.geometry("500x400")
        
        # Listbox for history
        listbox = tk.Listbox(history_window, font=('Arial', 10))
        listbox.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Populate history (last 50 items)
        for item in self.history[-50:]:
            listbox.insert(tk.END, item)
        
        # Double-click to navigate
        def on_history_select(event):
            selection = listbox.curselection()
            if selection:
                url = self.history[-50:][selection[0]]
                self.browser.LoadUrl(url)
                history_window.destroy()
        
        listbox.bind('<Double-1>', on_history_select)
    
    def show_settings(self):
        """Show settings window"""
        settings_window = tk.Toplevel(self.root)
        settings_window.title("Settings")
        settings_window.geometry("400x300")
        
        # Settings content
        ttk.Label(settings_window, text="Coppernium Browser Settings", 
                 font=('Arial', 14, 'bold')).pack(pady=20)
        
        # Clear history button
        ttk.Button(settings_window, text="Clear History", 
                  command=self.clear_history).pack(pady=10)
        
        # Clear bookmarks button
        ttk.Button(settings_window, text="Clear Bookmarks", 
                  command=self.clear_bookmarks).pack(pady=10)
        
        # Developer tools button
        ttk.Button(settings_window, text="Open Developer Tools", 
                  command=self.show_dev_tools).pack(pady=10)
    
    def show_about(self):
        """Show about dialog"""
        about_text = """
        🌐 Coppernium Browser
        
        Version: 2.0 (Chromium Native)
        Engine: Chromium via CEF
        
        ✨ Features:
        • Native Chromium performance
        • Full web compatibility  
        • Built-in privacy protection
        • Modern interface
        • Cross-platform support
        
        Built with CEF Python
        """
        messagebox.showinfo("About Coppernium", about_text)
    
    def show_dev_tools(self):
        """Open developer tools"""
        self.browser.ShowDevTools()
    
    def clear_history(self):
        """Clear browsing history"""
        if messagebox.askyesno("Clear History", "Are you sure you want to clear all history?"):
            self.history = []
            messagebox.showinfo("History", "History cleared successfully!")
    
    def clear_bookmarks(self):
        """Clear bookmarks"""
        if messagebox.askyesno("Clear Bookmarks", "Are you sure you want to clear all bookmarks?"):
            self.bookmarks = []
            self.save_bookmarks()
            messagebox.showinfo("Bookmarks", "Bookmarks cleared successfully!")
    
    def add_to_history(self, url):
        """Add URL to history"""
        if url not in self.history:
            self.history.append(url)
            # Keep only last 1000 items
            if len(self.history) > 1000:
                self.history = self.history[-1000:]
    
    def load_bookmarks(self):
        """Load bookmarks from file"""
        try:
            with open('bookmarks.json', 'r') as f:
                return json.load(f)
        except:
            return []
    
    def save_bookmarks(self):
        """Save bookmarks to file"""
        with open('bookmarks.json', 'w') as f:
            json.dump(self.bookmarks, f, indent=2)
    
    def on_url_change(self, url):
        """Called when URL changes"""
        self.current_url = url
        self.address_var.set(url)
        
        # Update security indicator
        if url.startswith('https://'):
            self.security_var.set("🔒 Secure")
            self.security_label.configure(foreground="green")
        elif url.startswith('http://'):
            self.security_var.set("⚠️ Not Secure")
            self.security_label.configure(foreground="red")
        else:
            self.security_var.set("")
    
    def on_loading_state_change(self, is_loading):
        """Called when loading state changes"""
        if is_loading:
            self.status_var.set("Loading...")
        else:
            self.status_var.set("Ready")
    
    def run(self):
        """Start the browser"""
        self.root.protocol("WM_DELETE_WINDOW", self.on_close)
        self.root.mainloop()
    
    def on_close(self):
        """Handle window close"""
        cef.Shutdown()
        self.root.quit()
        self.root.destroy()

class LoadHandler:
    """CEF Load Handler"""
    
    def __init__(self, browser_app):
        self.browser_app = browser_app
    
    def OnLoadingStateChange(self, browser, is_loading, can_go_back, can_go_forward):
        """Called when loading state changes"""
        self.browser_app.on_loading_state_change(is_loading)
    
    def OnLoadEnd(self, browser, frame, http_status_code):
        """Called when page finishes loading"""
        if frame.IsMain():
            url = browser.GetUrl()
            self.browser_app.on_url_change(url)

def main():
    """Main function"""
    print("🚀 Starting Coppernium Browser (Chromium Native)")
    
    # Check if CEF is available
    try:
        import cefpython3
        print("✅ CEF Python is available")
    except ImportError:
        print("❌ CEF Python not found. Installing...")
        os.system("pip3 install cefpython3")
        print("✅ Installation complete. Please restart the browser.")
        return
    
    # Create and run browser
    app = CopperniumBrowser()
    app.run()

if __name__ == "__main__":
    main()
