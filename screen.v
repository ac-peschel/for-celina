struct Screen {
	mut:
	width int
	height int
}

fn (mut s Screen) update_size(new_width int, new_height int) {
	if s.width != new_width || s.height != new_height {
		s.clear()
	}
	s.width = new_width
	s.height = new_height
}

fn (s Screen) print_text_centered(text string, y_offset int) {
	text_len := text.len
	start_pos := (s.width / 2) - (text_len / 2)
	if start_pos < 0 {
		s.move_cursor(s.width / 2, (s.height / 2) + y_offset)
		print("X")
	} else {
		s.move_cursor(start_pos, (s.height / 2) + y_offset)
		print(text.replace("*", " "))
		//s.custom_print(text, start_pos, (s.height / 2) + y_offset)
	}
}

fn (s Screen) custom_print(text string, start_x int, start_y int) {
	s.move_cursor(start_x, start_y)
	r := text.runes()
	for i := 0; i < r.len; i++ {
		if r[i] != `*` {
			s.move_cursor(start_x + i, start_y)
			print(r[i])
		}
	}
}

fn split_lines(obj string, cols int) []string {
	mut lines := []string{}
	r := obj.runes()
	for i := 0; i < r.len; i += cols {
		end := if i + cols > r.len { r.len } else { i + cols }
		lines << r[i..end].string()
	}
	return lines
}

fn (s Screen) print_centered_object(obj string, cols int) {
	lines := split_lines(obj, cols)
	center := lines.len / 2
	for i, line in lines {
		y_offset := i - center
		s.print_text_centered(line, y_offset + 8)
	}
}

fn (s Screen) draw_title(width int, height int) {
	center_x := width / 2
	center_y := height / 2
	flower_height := get_peony().len / get_line_length()
	mut vert_offset := center_y - (flower_height / 2) - 6
	if vert_offset < 3 {
		vert_offset = 3
	}
	fx := center_x - 22
	s.move_cursor(fx, vert_offset)
	print(" _____ _   _ ____     ____ _____ _     ___ _   _    _   ")
	s.move_cursor(fx, vert_offset + 1)
	print("|  ___(_) (_)  _ \\   / ___| ____| |   |_ _| \\ | |  / \\  ")
	s.move_cursor(fx, vert_offset + 2)
	print("| |_  | | | | |_) | | |   |  _| | |    | ||  \\| | / _ \\   ")
	s.move_cursor(fx, vert_offset + 3)
	print("|  _| | |_| |  _ <  | |___| |___| |___ | || |\\  |/ ___ \\  ")
	s.move_cursor(fx, vert_offset + 4)
	print("|_|    \\___/|_| \\_\\  \\____|_____|_____|___|_| \\_/_/   \\_\\")
}

fn (s Screen) draw_heart(width int, height int, h_offset int) {
	center_x := width / 2
	center_y := height / 2
	flower_height := get_peony().len / get_line_length()
	mut vert_offset := center_y - (flower_height / 2) - 6
	if vert_offset < 3 {
		vert_offset = 3
	}
	fx := center_x + h_offset
	s.move_cursor(fx, vert_offset)
	print(",d88b.d88b,")
	s.move_cursor(fx, vert_offset + 1)
	print("88888888888")
	s.move_cursor(fx, vert_offset + 2)
	print("`Y8888888Y'")
	s.move_cursor(fx, vert_offset + 3)
	print("  `Y888Y'")
	s.move_cursor(fx, vert_offset + 4)
	print("    `Y'")
}

fn (s Screen) erase_particle(p Particle) {
	s.move_cursor(p.last_x, p.last_y)
	print(" ")
}

fn (s Screen) draw_particle(p Particle) {
	s.move_cursor(int(p.x), int(p.y))
	print("${p.sym}")
}

fn (s Screen) move_cursor(x int, y int) {
	print("\x1b[${y};${x}H")
}

fn (s Screen) reset_cursor() {
	print("\x1b[H")
}

fn (s Screen) move_cursor_up() {
	print("\x1b[nA")
}

fn (s Screen) move_cursor_down() {
	print("\x1b[nB")
}

fn (s Screen) move_cursor_left() {
	print("\x1b[nD")
}

fn (s Screen) move_cursor_right() {
	print("\x1b[nC")
}

fn (s Screen) clear() {
	print("\x1b[2J")
}

fn (s Screen) clear_line() {
	print("\x1b[2K")
}

fn (s Screen) hide_cursor() {
	print("\x1b[?25l")
}

fn (s Screen) show_cursor() {
	print("\x1b[?25h")
}

fn (s Screen) activate_alt_buffer() {
	print("\x1b[?1049h")
}

fn (s Screen) deactivate_alt_buffer() {
	print("\x1b[?1049l")
}

fn (s Screen) set_fg_color(c TermColor) {
	print("\x1b[${int(c)}m")
}

enum TermColor {
	black = 30
	red
	green
	yellow
	blue
	magenta
	cyan
	white
}
