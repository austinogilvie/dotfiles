#!/usr/bin/env python3
"""
normalize_ascii.py

Replace common “fancy” Unicode punctuation characters with simple ASCII
equivalents.

Examples:
- “ ” → "
- ‘ ’ → '
- — – → -
"""

import sys


TRANSLATION_MAP = {
    # Double quotes
    "“": '"',
    "”": '"',
    "„": '"',
    "«": '"',
    "»": '"',

    # Single quotes / apostrophes
    "‘": "'",
    "’": "'",
    "‚": "'",
    "‹": "'",
    "›": "'",

    # Dashes
    "—": "-",
    "–": "-",
    "―": "-",

    # Ellipsis
    "…": "...",
}


def normalize_text(text: str) -> str:
    """
    Replace fancy Unicode punctuation with ASCII equivalents.
    """
    for fancy, plain in TRANSLATION_MAP.items():
        text = text.replace(fancy, plain)
    return text


def main() -> None:
    """
    Read from stdin, normalize text, write to stdout.
    """
    input_text = sys.stdin.read()
    output_text = normalize_text(input_text)
    sys.stdout.write(output_text)


if __name__ == "__main__":
    main()
