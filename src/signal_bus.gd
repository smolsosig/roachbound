extends Node

signal dialogue_register(stage_name: String)
signal dialogue_show(key: String)
signal dialogue_ended(key: String)

signal choice_show(text1: String, text2: String, big_one: bool)
signal choice_chosen(first: bool)

signal battle_done
