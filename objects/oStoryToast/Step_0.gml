var fi = fade_in_ms;
var hold = hold_ms;
var fo = fade_out_ms;
var total = fi + hold + fo;

if (current_time - start_ms >= total) {
    instance_destroy();
}
