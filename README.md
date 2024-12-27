# Work in Progress Repository

This repository showcases my ongoing projects and consists of three main folders: **FAUST**, **HISE**, and **UI Snippets**.

## Projects

### PumpComp (Scriptnode + Compressor.dsp)
A glue audio compressor with tempo sync functionality.  
The user can set attack and release times based on the tempo provided by the DAW.  
*(Example: Attack set to 1/128 and Release to 1/256t)*  

The core logic of the compressor is implemented in FAUST and is available in this HISE project or within the repository named **"Faust DSP"**.

Attack and release times are calculated inside Scriptnode.  

**Important:** This plugin requires recompiling and modifying the HISE source code as described in this forum post:  
[Tempo Sync Node Faster Than 1/64T](https://forum.hise.audio/topic/10664/tempo_sync-node-faster-than-1-64t)

---

### Respiro (Scriptnode + StereoWidener.dsp)
A multiband stereo widener that adjusts stereo width in different frequency bands and forces subfrequencies into mono.

---

### De- (Scriptnode)
A dynamic filter suite for:  
- **De-Boxing**: Removing boxy resonances  
- **De-Harshing**: Taming harsh frequencies  
- **De-Essing**: Reducing sibilance

---

### AAReverb (Scriptnode + FDNReverb.dsp) [Coming Soon]
An adaptive and automatic reverb designed with innovative features:  

#### Adaptive:  
The reverb intensity is adjusted dynamically using an envelope follower. It becomes less pronounced when the signal is strong and more prominent when the signal is weak.

#### Automatic:  
The user only needs to choose the room size, and the plugin automatically sets pre-delay and decay times.  
For example, if the DAW is set to 120 BPM, the user can select from the following rooms:  

| Room Type           | Pre-Delay   | Decay         | Total Reverb Duration |
|---------------------|-------------|---------------|-----------------------|
| Tight Ambience      | 3.91 ms     | 496.09 ms     | 500 ms               |
| Small Room          | 15.63 ms    | 984.38 ms     | 1000 ms              |
| Large Room          | 31.25 ms    | 1968.75 ms    | 2000 ms              |

...and so on.

---

Stay tuned for updates and new additions to these projects!
