import unittest
from unittest.mock import MagicMock, patch
from app.app import Handler


class TestApplication(unittest.TestCase):

    @patch("app.app.Handler.send_response")
    @patch("app.app.Handler.send_header")
    @patch("app.app.Handler.end_headers")
    def test_handler_response(
        self,
        mock_end_headers,
        mock_send_header,
        mock_send_response
    ):
        handler = Handler.__new__(Handler)

        handler.wfile = MagicMock()

        handler.do_GET()

        mock_send_response.assert_called_once_with(200)

        mock_send_header.assert_called_once_with(
            "Content-type",
            "text/plain"
        )

        mock_end_headers.assert_called_once()

        handler.wfile.write.assert_called_once_with(
            b"8byte DevOps Assignment - application\n"
        )


if __name__ == "__main__":
    unittest.main()
