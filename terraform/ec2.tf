resource "aws_instance" "app_1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.app.id]

  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y python3

    mkdir -p /opt/8byte-app

    cat > /opt/8byte-app/app.py <<'PYEOF'
    from http.server import BaseHTTPRequestHandler, HTTPServer

    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(b"8byte DevOps Assignment - Application Server 1")

        def log_message(self, format, *args):
            print("%s - %s" % (self.address_string(), format % args))

    server = HTTPServer(("0.0.0.0", 8080), Handler)
    server.serve_forever()
    PYEOF

    cat > /etc/systemd/system/8byte-app.service <<'SERVICE'
    [Unit]
    Description=8byte DevOps Assignment Application
    After=network.target

    [Service]
    ExecStart=/usr/bin/python3 /opt/8byte-app/app.py
    Restart=always
    User=root

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable 8byte-app
    systemctl start 8byte-app
  EOF

  tags = {
    Name = "${var.project_name}-app-1"
  }
}

resource "aws_instance" "app_2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_2.id
  vpc_security_group_ids = [aws_security_group.app.id]

  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y python3

    mkdir -p /opt/8byte-app

    cat > /opt/8byte-app/app.py <<'PYEOF'
    from http.server import BaseHTTPRequestHandler, HTTPServer

    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(b"8byte DevOps Assignment - Application Server 2")

        def log_message(self, format, *args):
            print("%s - %s" % (self.address_string(), format % args))

    server = HTTPServer(("0.0.0.0", 8080), Handler)
    server.serve_forever()
    PYEOF

    cat > /etc/systemd/system/8byte-app.service <<'SERVICE'
    [Unit]
    Description=8byte DevOps Assignment Application
    After=network.target

    [Service]
    ExecStart=/usr/bin/python3 /opt/8byte-app/app.py
    Restart=always
    User=root

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable 8byte-app
    systemctl start 8byte-app
  EOF

  tags = {
    Name = "${var.project_name}-app-2"
  }
}
