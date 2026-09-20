import pytest

from main import main


def test_main_prints_greeting(capsys: pytest.CaptureFixture[str]) -> None:
    main()
    assert capsys.readouterr().out == "Hello, world!\n"
