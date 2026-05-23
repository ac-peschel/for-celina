import rand
import math

struct Particle {
	mut:
	x f32
	y f32
	last_x int
	last_y int
	vx f32
	vy f32
	sym string
}

fn new_particle(cx int, cy int) Particle {
	syms := ["@", "o", "."]
	angle := rand.f32() * f32(math.pi * 2.0)
	speed := 0.3 + rand.f32() * 0.7
	return Particle{
		x: cx,
		y: cy,
		last_x: cx,
		last_y: cy,
		vx: f32(math.cos(angle) * speed),
		vy: f32(math.sin(angle) * speed),
		sym: syms[rand.intn(syms.len) or {0}]
	}
}

fn (mut p Particle) update() {
	p.last_x = int(p.x)
	p.last_y = int(p.y)

	p.vx += (rand.f32() - 0.5) * 0.08
	p.vy += (rand.f32() - 0.5) * 0.08

	p.x += p.vx
	p.y += p.vy
}

fn (p Particle) alive(width int, height int) bool {
	return p.x >= 0
		&& p.y >= 0
		&& p.x < width
		&& p.y < height
}
