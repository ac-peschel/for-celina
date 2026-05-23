import term
import time
import rand

fn is_behind_flower(x f32, y f32, cx int, cy int) bool {
   p_width := get_line_length()
   p_height := (get_peony().len / get_line_length() + 16)
   interfers_h := (x > cx + (p_width / 2))
      || (x < cx - (p_width / 2))
   interfers_v := (y > cy + (p_height / 2))
      || (y < cy - (p_height / 2))

   return interfers_h || interfers_v
}

fn main() {
   mut s := Screen{
      width: 0,
      height: 0,
   }
   s.activate_alt_buffer()
   s.hide_cursor()
   s.clear()

   mut particles := []Particle{}

   for {
      width, height := term.get_terminal_size()
      s.update_size(width, height)
      center_x := width / 2
      center_y := height / 2
      if width < get_line_length() || height < (get_peony().len /get_line_length() + 8) {
         s.print_text_centered("terminal too small", 0)
      } else {
         s.set_fg_color(TermColor.white)
         // particle
         spawn_count := rand.int_in_range(2, 5) or { 1 }
         for _ in 0 .. spawn_count {
            particles << new_particle(center_x, center_y)
         }
         for p in particles {
            if is_behind_flower(p.x, p.y, center_x, center_y) {
               s.erase_particle(p)
            }
         }
         for mut p in particles {
            p.update()
         }
         mut alive_particles := []Particle{}
         for p in particles {
            if p.alive(width, height) {
               alive_particles << p
            } else {
               if is_behind_flower(p.x, p.y, center_x, center_y) {
                  s.erase_particle(p)
               }
            }
         }
         unsafe { particles = alive_particles }
         for p in particles {
            if is_behind_flower(p.x, p.y, center_x, center_y) {
               s.draw_particle(p)
            }
         }

         s.set_fg_color(TermColor.magenta)
         s.print_centered_object(get_peony(), get_line_length())

         s.set_fg_color(TermColor.red)
         s.draw_heart(width, height, 40)
         s.draw_heart(width, height, -40)
         s.set_fg_color(TermColor.white)
         s.draw_title(width, height)
      }

      time.sleep(16 * time.millisecond)
   }
}
