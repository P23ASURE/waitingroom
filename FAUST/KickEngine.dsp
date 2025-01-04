declare name "Kick F*cktory - all I need is U";
declare description "Stereo Kick synthesizer";
declare version "0.2.4";

import("stdfaust.lib");

//---------------------- TUNING ----------------------
// Common kick tunings in Hz (E1 through B1)
tune_select = nentry("0_Tuning/Tune End[style:menu{'E1':41.2;'F1':43.65;'F#1':46.25;'G1':49;'G#1':51.91;'A1':55;'A#1':58.27;'B1':61.74}]", 46.25, 41.2, 61.74, 0.01);

//---------------------- CLICK LAYERS ----------------------
// High click - for attack/snap (1-4kHz)
click1_freq = hslider("1_Click/High Click/1_Frequency[style:knob]", 2000, 1000, 4000, 1) : si.smoo;
click1_res = hslider("1_Click/High Click/2_Resonance[style:knob]", 1.2, 0.1, 4.0, 0.1) : si.smoo;
click1_decay = hslider("1_Click/High Click/3_Decay[style:knob]", 0.004, 0.001, 0.02, 0.001) : si.smoo;
click1_level = hslider("1_Click/High Click/4_Level[style:knob]", 0.7, 0, 1, 0.01) : si.smoo;

// Mid click - for body/punch (400-800Hz)
click2_freq = hslider("1_Click/Mid Click/1_Frequency[style:knob]", 600, 400, 800, 1) : si.smoo;
click2_res = hslider("1_Click/Mid Click/2_Resonance[style:knob]", 2.0, 0.1, 6.0, 0.1) : si.smoo;
click2_decay = hslider("1_Click/Mid Click/3_Decay[style:knob]", 0.008, 0.001, 0.03, 0.001) : si.smoo;
click2_level = hslider("1_Click/Mid Click/4_Level[style:knob]", 0.5, 0, 1, 0.01) : si.smoo;

// Click type selector
click_type = hslider("1_Click/Click Character[style:knob]", 0.5, 0, 1, 0.01) : si.smoo;

//---------------------- BODY CONTROLS ----------------------
// Multiplier for start frequency (4 = two octaves up, 8 = three octaves up, 16 = four octaves up)
start_mult = hslider("2_Body/1_Start Multiplier[style:knob]", 8, 4, 16, 0.5) : si.smoo;
pitch_end = select2(tune_select>0, hslider("2_Body/2_End[style:knob]", 45, 30, 80, 1), tune_select) : si.smoo;
pitch_start = pitch_end * start_mult;
pitch_decay = hslider("2_Body/3_Pitch Decay[style:knob]", 0.04, 0.02, 0.2, 0.001) : si.smoo;
body_shape = hslider("2_Body/4_Shape[style:knob]", 0.3, 0, 1, 0.01) : si.smoo;

//---------------------- SUB CONTROLS ----------------------
sub_freq = hslider("3_Sub/1_Frequency[style:knob]", 35, 25, 50, 1) : si.smoo;
sub_decay = hslider("3_Sub/2_Decay[style:knob]", 0.15, 0.05, 0.4, 0.01) : si.smoo;
sub_level = hslider("3_Sub/3_Level[style:knob]", 0.6, 0, 1, 0.01) : si.smoo;

//---------------------- COLOR CONTROLS ----------------------
morph = hslider("4_Color/1_Clean > Acid[style:knob]", 0, 0, 1, 0.01) : si.smoo;
res_amount = hslider("4_Color/2_Resonance[style:knob]", 0.3, 0, 1, 0.01) : si.smoo;
res_freq = hslider("4_Color/3_Res Freq[style:knob]", 400, 100, 1000, 1) : si.smoo;
acid_env = hslider("4_Color/4_Env Amount[style:knob]", 0.5, 0, 1, 0.01) : si.smoo;

// Drive section
drive_type = hslider("4_Color/5_Drive Type[style:knob]", 0.5, 0, 1, 0.01) : si.smoo;
drive_amount = hslider("4_Color/6_Drive Amount[style:knob]", 0.3, 0, 1, 0.01) : si.smoo;
harmonics = hslider("4_Color/7_Harmonics[style:knob]", 0.5, 0, 1, 0.01) : si.smoo;

//---------------------- ENVELOPE CONTROLS ----------------------
attack = hslider("5_Envelope/1_Attack[style:knob]", 0.0005, 0.0001, 0.01, 0.0001) : si.smoo;
decay = hslider("5_Envelope/2_Decay[style:knob]", 0.3, 0.1, 1.0, 0.01) : si.smoo;
sustain = hslider("5_Envelope/3_Sustain[style:knob]", 0.0, 0.0, 0.5, 0.01) : si.smoo;
release = hslider("5_Envelope/4_Release[style:knob]", 0.1, 0.01, 0.5, 0.01) : si.smoo;

//---------------------- STEREO CONTROLS ----------------------
stereo_width = hslider("6_Stereo/1_Width[style:knob]", 0.0, 0.0, 1.0, 0.01) : si.smoo;
stereo_pan = hslider("6_Stereo/2_Pan[style:knob]", 0.5, 0.0, 1.0, 0.01) : si.smoo;

//---------------------- SYNTHESIS ----------------------
trigger = button("gate");

//--- Click Generation ---
noise = no.noise;
noise_bright = noise : fi.highpass(4, 1000); // Pre-filtered noise for brighter character
noise_full = noise;

// High click layer (snap/attack)
click1_env = trigger : en.ar(0.0001, click1_decay);
click1_bp = fi.resonbp(click1_freq, click1_res, 1.0);
click1_clean = (noise_bright : click1_bp) * click1_env * click1_level;
click1_hard = (noise_bright : click1_bp : ma.tanh) * click1_env * click1_level;
click1 = click1_clean * (1-click_type) + click1_hard * click_type;

// Mid click layer (body/punch)
click2_env = trigger : en.ar(0.0001, click2_decay);
click2_bp = fi.resonbp(click2_freq, click2_res, 1.0);
click2_clean = (noise_full : click2_bp) * click2_env * click2_level;
click2_hard = (noise_full : click2_bp : ma.tanh) * click2_env * click2_level;
click2 = click2_clean * (1-click_type) + click2_hard * click_type;

// Combined click
click = click1 + click2;

//--- Body Generation ---
pitch_env = trigger : en.ar(0.001, pitch_decay);
pitch_mod = (pitch_start - pitch_end) * pitch_env + pitch_end;

// Resonant filter envelope for acid character
acid_mod = (trigger : en.ar(0.001, pitch_decay * 2)) * acid_env * morph;
filter_freq = res_freq * (1 + acid_mod);
resonance = 1 + (res_amount * 8 * morph);

// Basic oscillators
sine = os.osc(pitch_mod);
triangle = os.triangle(pitch_mod);
saw = os.sawtooth(pitch_mod);

// Morph between clean and acid tones
clean = sine * (1 - body_shape) + triangle * body_shape;
acid = saw : fi.resonlp(filter_freq, resonance, 1);
body = clean * (1 - morph) + acid * morph;

//--- Sub Generation ---
sub_env = trigger : en.ar(0.001, sub_decay);
sub = os.osc(sub_freq) * sub_env * sub_level;

//--- Drive Processing ---
soft_clip(x) = ma.tanh(x * (1 + drive_amount * 10));
hard_clip(x) = min(1, max(-1, x * (1 + drive_amount * 5)));
wave_fold(x) = sin(x * (1 + drive_amount * ma.PI));

// Drive section - clean morphing to driven
body_driven = body * (1 - drive_type) + (body : hard_clip) * drive_type;

//--- Harmonics Enhancement ---
harmonics_gen(x) = x + (x * x * x * harmonics * 0.3);

//--- Main Envelope ---
main_env = trigger : en.adsr(attack, decay, sustain, release);

//--- Final Mix and Stereo Processing ---
mono_signal = (click + body_driven + sub) * main_env : harmonics_gen;

stereo_processor(mono_in) = mono_in <: _,_ : 
    stereo_spread : stereo_panner
with {
    stereo_spread = _ * (1 + stereo_width), _ * (1 - stereo_width);
    stereo_panner = _ * sqrt(1 - stereo_pan), _ * sqrt(stereo_pan);
};

process = mono_signal * 0.7 : stereo_processor;
