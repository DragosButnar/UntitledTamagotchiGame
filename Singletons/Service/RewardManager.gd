extends Node

# Money earning parameters
const MONEY_CHANCE := 1
const MONEY_MIN := 1
const MONEY_MAX := 10

	
func try_grant_activity_reward() -> String:
	if randf() <= MONEY_CHANCE:
		var amount = randi_range(MONEY_MIN, MONEY_MAX)
		PlayerManager.add_currency(amount)
		return "Earned %d coins!" % amount
	else:
		return "No money earned..."
