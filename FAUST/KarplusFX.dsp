import("stdfaust.lib");
// Karplus-Strong -like Resonator
process = _ : *(0.7) : 
    (+ : @(delayLength-1)) ~ (*(damping)) : 
    lowpass with {
    
    freq = hslider("freq", 55, 20, 500, 1);
    delayLength = ma.SR/freq;
    damping = hslider("damping", 0.95, 0.8, 0.99, 0.001);
    lowpass = fi.lowpass(1, 4000);
};