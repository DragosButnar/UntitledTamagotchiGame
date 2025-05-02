extends Node

const PLAYER1_STARTING_POSITION := Vector2(-308,0)
const PLAYER2_STARTING_POSITION := Vector2(308,0)
const BALL_STARTING_POSITION := Vector2(0,0)
const WIN_SCORE := 5
const BALL_TIMEOUT_LENGTH := 3
const EXIT_DELAY := 3

signal game_paused
signal game_resumed
signal scores_updated
signal player_scored(player)
signal game_win(player)
signal wall_touched
signal wall_left
