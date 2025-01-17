extends EnemyCore

const BULLET_GRAVITY = 640

var enemy_explosion = preload("res://Entities/Enemy/Obj/LargeExplosionEnemy.tscn")

onready var bullet_bhv := $BulletBehavior as FJ_BulletBehavior

onready var dmg_area = $DamageArea

func _physics_process(delta: float) -> void:
	var bodies = dmg_area.get_overlapping_bodies()
	
	for i in bodies:
		if i is TileMap:
			var en = enemy_explosion.instance()
			get_parent().add_child(en)
			en.global_position = self.global_position
			en.database.general.combat.contact_damage = self.database.general.combat.contact_damage
			
			FJ_AudioManager.sfx_combat_ballade_cracker_bomb.play()
			
			queue_free_start(false)
			return

func _on_BulletBehavior_stopped_moving() -> void:
	bullet_bhv.gravity = BULLET_GRAVITY
