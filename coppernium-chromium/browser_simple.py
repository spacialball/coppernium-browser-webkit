#!/usr/bin/env python3
"""
Coppernium Browser Simple - Navegador web usando WebKitGTK
Una alternativa simple que usa las librerías del sistema
"""

import gi
import sys
import json
import os
from urllib.parse import urlparse

gi.require_version('Gtk', '3.0')
gi.require_version('WebKit2', '4.1')

from gi.repository import Gtk, WebKit2, Gio, GdkPixbuf, Gdk

class CopperniumSimple:
    def __init__(self):
        self.current_url = ""
        self.bookmarks_file = "bookmarks_simple.json"
        self.bookmarks = self.load_bookmarks()
        self.history = []
        
        # Create window
        self.window = Gtk.Window()
        self.window.set_title("🌐 Coppernium Browser - WebKit Native")
        self.window.set_default_size(1200, 800)
        self.window.connect("destroy", Gtk.main_quit)
        
        self.create_ui()
        
        # Show window
        self.window.show_all()
        
        # Load Google by default
        self.webview.load_uri("https://www.google.com")
    
    def create_ui(self):
        """Create the browser interface"""
        
        # Main vertical box
        vbox = Gtk.VBox(spacing=5)
        self.window.add(vbox)
        
        # Toolbar
        toolbar = Gtk.HBox(spacing=5)
        toolbar.set_margin_start(10)
        toolbar.set_margin_end(10)
        toolbar.set_margin_top(10)
        vbox.pack_start(toolbar, False, False, 0)
        
        # Navigation buttons
        back_btn = Gtk.Button(label="←")
        back_btn.set_tooltip_text("Back")
        back_btn.connect("clicked", self.go_back)
        toolbar.pack_start(back_btn, False, False, 0)
        
        forward_btn = Gtk.Button(label="→")
        forward_btn.set_tooltip_text("Forward")  
        forward_btn.connect("clicked", self.go_forward)
        toolbar.pack_start(forward_btn, False, False, 0)
        
        reload_btn = Gtk.Button(label="⟳")
        reload_btn.set_tooltip_text("Reload")
        reload_btn.connect("clicked", self.reload)
        toolbar.pack_start(reload_btn, False, False, 0)
        
        home_btn = Gtk.Button(label="🏠")
        home_btn.set_tooltip_text("Home")
        home_btn.connect("clicked", self.go_home)
        toolbar.pack_start(home_btn, False, False, 0)
        
        # Address bar
        self.address_entry = Gtk.Entry()
        self.address_entry.set_placeholder_text("Enter URL or search...")
        self.address_entry.connect("activate", self.navigate_to)
        toolbar.pack_start(self.address_entry, True, True, 5)
        
        # Go button
        go_btn = Gtk.Button(label="Go")
        go_btn.connect("clicked", self.navigate_to)
        toolbar.pack_start(go_btn, False, False, 0)
        
        # Bookmark button
        bookmark_btn = Gtk.Button(label="⭐")
        bookmark_btn.set_tooltip_text("Bookmark this page")
        bookmark_btn.connect("clicked", self.add_bookmark)
        toolbar.pack_start(bookmark_btn, False, False, 0)
        
        # Menu button
        menu_btn = Gtk.Button(label="≡")
        menu_btn.set_tooltip_text("Menu")
        menu_btn.connect("clicked", self.show_menu)
        toolbar.pack_start(menu_btn, False, False, 0)
        
        # WebView
        self.webview = WebKit2.WebView()
        
        # WebView settings for better compatibility
        settings = self.webview.get_settings()
        settings.set_property('enable-javascript', True)
        settings.set_property('enable-media-stream', True)
        settings.set_property('enable-webgl', True)
        settings.set_property('enable-accelerated-2d-canvas', True)
        settings.set_property('enable-html5-database', True)
        settings.set_property('enable-html5-local-storage', True)
        settings.set_property('user-agent', 
                            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/605.1.15 (KHTML, like Gecko) '
                            'CopperniumBrowser/2.0 Safari/605.1.15')
        
        # WebView event handlers
        self.webview.connect("load-changed", self.on_load_changed)
        
        # Scroll window for webview
        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scroll.add(self.webview)
        vbox.pack_start(scroll, True, True, 0)
        
        # Status bar
        self.status_bar = Gtk.Statusbar()
        self.status_context = self.status_bar.get_context_id("status")
        self.status_bar.push(self.status_context, "Ready")
        vbox.pack_start(self.status_bar, False, False, 0)
    
    def navigate_to(self, widget=None):
        """Navigate to URL from address bar"""
        url = self.address_entry.get_text().strip()
        if not url:
            return
        
        # Format URL
        if not url.startswith(('http://', 'https://')):
            if '.' in url and ' ' not in url:
                url = 'https://' + url
            else:
                # Search query
                url = f"https://www.google.com/search?q={url.replace(' ', '+')}"
        
        self.webview.load_uri(url)
        self.add_to_history(url)
    
    def go_back(self, widget):
        """Navigate back"""
        if self.webview.can_go_back():
            self.webview.go_back()
    
    def go_forward(self, widget):
        """Navigate forward"""
        if self.webview.can_go_forward():
            self.webview.go_forward()
    
    def reload(self, widget):
        """Reload current page"""
        self.webview.reload()
    
    def go_home(self, widget):
        """Go to home page"""
        self.webview.load_uri("https://www.google.com")
    
    def on_load_changed(self, webview, load_event):
        """Handle page load events"""
        if load_event == WebKit2.LoadEvent.STARTED:
            self.status_bar.push(self.status_context, "Loading...")
        elif load_event == WebKit2.LoadEvent.FINISHED:
            self.status_bar.push(self.status_context, "Ready")
            uri = webview.get_uri()
            if uri:
                self.current_url = uri
                self.address_entry.set_text(uri)
    
    def add_bookmark(self, widget):
        """Add current page to bookmarks"""
        if not self.current_url:
            return
        
        # Simple dialog for bookmark name
        dialog = Gtk.MessageDialog(
            parent=self.window,
            modal=True,
            message_type=Gtk.MessageType.QUESTION,
            buttons=Gtk.ButtonsType.OK_CANCEL,
            text="Add Bookmark"
        )
        
        dialog.format_secondary_text("Enter bookmark name:")
        
        entry = Gtk.Entry()
        entry.set_text(self.current_url)
        dialog.get_content_area().pack_start(entry, True, True, 0)
        dialog.show_all()
        
        response = dialog.run()
        if response == Gtk.ResponseType.OK:
            title = entry.get_text().strip()
            if title:
                self.bookmarks.append({
                    'title': title,
                    'url': self.current_url,
                    'timestamp': len(self.bookmarks)
                })
                self.save_bookmarks()
                self.show_message("Bookmark added successfully!")
        
        dialog.destroy()
    
    def show_menu(self, widget):
        """Show context menu"""
        menu = Gtk.Menu()
        
        # Home
        home_item = Gtk.MenuItem(label="🏠 Home")
        home_item.connect("activate", self.go_home)
        menu.append(home_item)
        
        menu.append(Gtk.SeparatorMenuItem())
        
        # Bookmarks
        bookmarks_item = Gtk.MenuItem(label="⭐ Show Bookmarks")
        bookmarks_item.connect("activate", self.show_bookmarks)
        menu.append(bookmarks_item)
        
        # History
        history_item = Gtk.MenuItem(label="📜 Show History")
        history_item.connect("activate", self.show_history)
        menu.append(history_item)
        
        menu.append(Gtk.SeparatorMenuItem())
        
        # About
        about_item = Gtk.MenuItem(label="ℹ️ About")
        about_item.connect("activate", self.show_about)
        menu.append(about_item)
        
        menu.show_all()
        menu.popup(None, None, None, None, 0, Gtk.get_current_event_time())
    
    def show_bookmarks(self, widget):
        """Show bookmarks window"""
        if not self.bookmarks:
            self.show_message("No bookmarks saved yet.")
            return
        
        dialog = Gtk.Dialog(
            title="Bookmarks",
            parent=self.window,
            modal=True
        )
        dialog.set_default_size(500, 400)
        
        # Create liststore for bookmarks
        liststore = Gtk.ListStore(str, str)
        for bookmark in self.bookmarks:
            liststore.append([bookmark['title'], bookmark['url']])
        
        # Create treeview
        treeview = Gtk.TreeView(model=liststore)
        
        # Add columns
        title_column = Gtk.TreeViewColumn("Title", Gtk.CellRendererText(), text=0)
        url_column = Gtk.TreeViewColumn("URL", Gtk.CellRendererText(), text=1)
        treeview.append_column(title_column)
        treeview.append_column(url_column)
        
        # Handle double-click
        def on_row_activated(treeview, path, column):
            model = treeview.get_model()
            iter = model.get_iter(path)
            url = model.get_value(iter, 1)
            self.webview.load_uri(url)
            dialog.destroy()
        
        treeview.connect("row-activated", on_row_activated)
        
        # Add to dialog
        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scroll.add(treeview)
        
        dialog.get_content_area().pack_start(scroll, True, True, 0)
        dialog.add_button("Close", Gtk.ResponseType.CLOSE)
        
        dialog.show_all()
        dialog.run()
        dialog.destroy()
    
    def show_history(self, widget):
        """Show history window"""
        if not self.history:
            self.show_message("No history available.")
            return
        
        dialog = Gtk.Dialog(
            title="History",
            parent=self.window,
            modal=True
        )
        dialog.set_default_size(500, 400)
        
        # Create liststore for history
        liststore = Gtk.ListStore(str)
        for item in self.history[-50:]:  # Last 50 items
            liststore.append([item])
        
        # Create treeview
        treeview = Gtk.TreeView(model=liststore)
        column = Gtk.TreeViewColumn("URL", Gtk.CellRendererText(), text=0)
        treeview.append_column(column)
        
        # Handle double-click
        def on_row_activated(treeview, path, column):
            model = treeview.get_model()
            iter = model.get_iter(path)
            url = model.get_value(iter, 0)
            self.webview.load_uri(url)
            dialog.destroy()
        
        treeview.connect("row-activated", on_row_activated)
        
        # Add to dialog
        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scroll.add(treeview)
        
        dialog.get_content_area().pack_start(scroll, True, True, 0)
        dialog.add_button("Close", Gtk.ResponseType.CLOSE)
        
        dialog.show_all()
        dialog.run()
        dialog.destroy()
    
    def show_about(self, widget):
        """Show about dialog"""
        about = Gtk.AboutDialog()
        about.set_program_name("Coppernium Browser")
        about.set_version("2.0 (WebKit Native)")
        about.set_comments("Un navegador web moderno basado en WebKit")
        about.set_website("https://github.com/coppernium")
        about.set_website_label("Coppernium Project")
        about.set_authors(["Sebastian"])
        about.set_license_type(Gtk.License.MIT_X11)
        
        about.run()
        about.destroy()
    
    def show_message(self, message):
        """Show info message"""
        dialog = Gtk.MessageDialog(
            parent=self.window,
            modal=True,
            message_type=Gtk.MessageType.INFO,
            buttons=Gtk.ButtonsType.OK,
            text=message
        )
        dialog.run()
        dialog.destroy()
    
    def add_to_history(self, url):
        """Add URL to history"""
        if url and url not in self.history:
            self.history.append(url)
            # Keep only last 1000 items
            if len(self.history) > 1000:
                self.history = self.history[-1000:]
    
    def load_bookmarks(self):
        """Load bookmarks from file"""
        try:
            if os.path.exists(self.bookmarks_file):
                with open(self.bookmarks_file, 'r') as f:
                    return json.load(f)
        except Exception as e:
            print(f"Error loading bookmarks: {e}")
        return []
    
    def save_bookmarks(self):
        """Save bookmarks to file"""
        try:
            with open(self.bookmarks_file, 'w') as f:
                json.dump(self.bookmarks, f, indent=2)
        except Exception as e:
            print(f"Error saving bookmarks: {e}")

def main():
    print("🚀 Starting Coppernium Browser (WebKit Native)")
    
    try:
        app = CopperniumSimple()
        Gtk.main()
    except Exception as e:
        print(f"Error starting browser: {e}")
        print("Make sure you have WebKitGTK installed:")
        print("sudo apt install gir1.2-webkit2-4.0 python3-gi")

if __name__ == "__main__":
    main()
