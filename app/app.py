from http.server import BaseHTTPRequestHandler, HTTPServer
import os


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()

        server_name = os.getenv("SERVER_NAME", "application")

        self.wfile.write(
            f"8byte DevOps Assignment - {server_name}\n".encode()
        )

    def log_message(self, format, *args):
        print("%s - %s" % (self.address_string(), format % args))


if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8080), Handler)
    print("Application listening on port 8080")
    server.serve_forever()
