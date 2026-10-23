#!/usr/bin/env python3
"""DS9's sound as an MP3 stream for the browser (port 6082).
Each listener gets its own fresh ffmpeg capture of the PulseAudio "ds9" sink, so nothing stale is
buffered while nobody is listening and the sound stays close to the picture."""
import http.server, socketserver, subprocess

CMD = ["ffmpeg", "-nostdin", "-v", "error", "-f", "pulse", "-fragment_size", "2048", "-i", "ds9.monitor",
       "-ac", "2", "-c:a", "libmp3lame", "-b:a", "128k", "-flush_packets", "1", "-f", "mp3", "-"]

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if not self.path.startswith("/ds9.mp3"):
            self.send_error(404); return
        self.send_response(200)
        self.send_header("Content-Type", "audio/mpeg")
        self.send_header("Cache-Control", "no-store")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        p = subprocess.Popen(CMD, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
        try:
            while chunk := p.stdout.read(4096):
                self.wfile.write(chunk)
        except (BrokenPipeError, ConnectionResetError):
            pass
        finally:
            p.kill(); p.wait()
    def log_message(self, *a):
        pass

class Server(socketserver.ThreadingMixIn, http.server.HTTPServer):
    daemon_threads = True
    allow_reuse_address = True

Server(("0.0.0.0", 6082), Handler).serve_forever()
