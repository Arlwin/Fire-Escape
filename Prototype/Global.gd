extends Node

# Game State
var rooms = 0
var gameOver = false
var paused = false

# Helpers
var tutorial = true
var slidingLevel = false

# Player State
var playerHealth = null
var playerVelocity = null
var playerUp = Vector2(0, -1)
