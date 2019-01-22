# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
Mime::Type.register "application/xls", :xls

Sprockets.register_mime_type 'application/json', extensions: ['.json'], charset: :unicode
Sprockets.register_mime_type 'application/ruby', extensions: ['.rb']
