import term
import time
import os

fn main() {
   mut s := Screen{
      width: 0,
      height: 0,
   }
   s.activate_alt_buffer()
   s.hide_cursor()
   s.clear()

   os.signal_opt(os.sigint, fn (sig os.Signal, s &Screen) {
      s.deactivate_alt_buffer()
      s.show_cursor()
      s.clear()
      s.set_fg_color(TermColor.white)
      exit(0)
   }, &s) or {}

   for {
      width, height := term.get_terminal_size()
      s.update_size(width, height)
      s.set_fg_color(TermColor.red)
      if width < get_line_length() || height < (get_peony().len /get_line_length()) {
         s.print_text_centered("terminal too small", 0)
      } else {
         s.print_centered_object(get_peony(), get_line_length())
      }

      time.sleep(16 * time.millisecond)
   }
}
