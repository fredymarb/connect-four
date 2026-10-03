# Connect Four

A command-line Connect Four game built in Ruby with test-driven development.

## Overview

This project implements a classic 2-player Connect Four game in the terminal. Players alternate turns, choose a column from 1 to 7, and try to connect four tokens horizontally, vertically, or diagonally before the other player does.

## TDD focus

The main goal of this project is to practice Test-Driven Development (TDD). The game was developed by writing specifications for desired behavior first in RSpec, then implementing the code needed to satisfy those tests, and finally validating the full behavior through the test suite.

## Current features

- 6x7 game board with token placement logic
- Two-player turn-based gameplay
- Input validation for column selection
- Full-column detection and retry flow
- Win detection for horizontal, vertical, and diagonal lines
- Winning tokens are highlighted in blue in the terminal
- Draw detection when the board fills up
- Save-and-quit support with resume-on-launch behavior
- JSON-based saved game state stored in the project root
- RSpec test suite covering the core game logic and behavior

## Getting started

Install dependencies and run the game:

```bash
bundle install
ruby main.rb
```

At the prompt, enter a column number from 1 to 7 to place a token, or press `q` to save the current game and exit.

If a saved game exists, the next time you launch the app you will be asked whether to continue the saved game or start a new one.

## Project structure

```text
.
├── lib/
│   ├── board.rb
│   ├── console.rb
│   ├── game.rb
│   ├── game_save.rb
│   └── player.rb
├── spec/
├── .connect_four_save.json
├── .rspec
├── Gemfile
├── Gemfile.lock
├── main.rb
├── README.md
└── .gitignore
```

## Testing

The repository includes an RSpec suite under `spec/`. In the current environment, it can be run directly with:

```bash
rspec
```

## Technologies

- Ruby
- RSpec
- RuboCop
