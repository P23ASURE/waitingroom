Processor 
Type SynthChain ID Preset Bypassed Gain 	      �?Balance 	        VoiceLimit 	      P@KillFadeTime 	      4@IconColour 0 packageName  BuildVersion �  EditorStates BodyShown 0 Visible 1 Solo 0 Folded 1  ChildProcessors  Processor Type MidiProcessorChain ID Midi Processor Bypassed EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors  Processor Type ScriptProcessor ID Interface Bypassed Script KContent.makeFrontInterface(600, 500);

const var CompressorFX = Synth.getEffect("Script FX1");

const var knbThreshold = Content.getComponent("knbThreshold");
const var knbRatio = Content.getComponent("knbRatio");

const var ScriptFX1 = Synth.getEffect("Script FX1");

const var rm = Engine.getGlobalRoutingManager();
const var GainLeft = rm.getCable("GainLeft");
const var GainRight = rm.getCable("GainRight");

	GainLeft.registerCallback(function (value)
	{
	
	Console.print(value);
	}, AsyncNotification);



namespace VuMeter
{
	/** Creates a peak meter.
	*
	*	Usage: Give it a reference to a module (either synth or effect).
	*
	*	It looks best using a width and height with multiple of 4.
	*	Customize the colours using the scriptPanel colour Ids
	*/
	inline function createVuMeter(name, x, y)
	{
		local widget = Content.addPanel(name, x, y);
    
		Content.setPropertiesFromJSON(name, {
		//"width": 16,
		//"height": 40,
		"itemColour": 0xFFffe467,     
		"itemColour2": 4279505940,
		"bgColour": 4279505940,
		"textColour": 4283782485,
		"saveInPreset": false,
		"opaque": 1
		});
    	
		widget.setPaintRoutine(function(g)
		{
			g.fillAll(this.get("bgColour"));
			
			g.setColour(this.get("itemColour"));
    	
			var lsize = parseInt(this.data.lvalue * (this.getHeight()-4));
			var rsize = parseInt(this.data.rvalue * (this.getHeight()-4));
    	
			g.fillRect([2, this.getHeight() - lsize - 2, (this.getWidth()-4)/2-1, lsize]);
			g.fillRect([2 + this.getWidth() / 2 - 1, this.getHeight() - rsize - 2, (this.getWidth()-4)/2-1, rsize]);
    	
			g.setColour(this.get("itemColour2"));
    	
			for(i = 1; i < this.getHeight()-1; i = i + 3)
			{
				g.fillRect([1, i, this.getWidth()-2, 1]);
			}
		});
    
		widget.setTimerCallback(function()
		{
			var lvalue;
			var rvalue;
			
			if(this.data.fx)
			{
				lvalue = getNormalizedPeakValue(this.data.fx.getCurrentLevel(1));
				rvalue = getNormalizedPeakValue(this.data.fx.getCurrentLevel(0));
			}
			else
			{
				lvalue = getNormalizedPeakValue(Engine.getMasterPeakLevel(1));
				rvalue = getNormalizedPeakValue(Engine.getMasterPeakLevel(0));
			}
			
			
    	
			this.data.lvalue = Math.max(lvalue, this.data.lvalue - 0.04);
			this.data.rvalue = Math.max(rvalue, this.data.rvalue - 0.04);
    	
			this.repaintImmediately();
		});
    
		widget.startTimer(30);
		return widget;
	};

	inline function setModule(vuMeter, module)
	{
		vuMeter.data.fx = module;
	}
	
	inline function getNormalizedPeakValue(gain)
	{
		return 0.01 * (100.0 + Engine.getDecibelsForGainFactor(gain));
	}
}






const var InputMeter = VuMeter.createVuMeter("InputMeter", 20,30);
//InputMeter.set("height", 156);
VuMeter.setModule(InputMeter, Synth.getEffect("Input"));


const var OutputMeter = VuMeter.createVuMeter("OutputMeter", 300, 30);
//OutputMeter.set("height", 156);
VuMeter.setModule(OutputMeter, Synth.getEffect("MasterOut"));


function onNoteOn()
{
	
}
 function onNoteOff()
{
	
}
 function onController()
{
	
}
 function onTimer()
{
	
}
 function onControl(number, value)
{
	
}
  EditorStates BodyShown 1 Visible 1 Solo 0 contentShown 1 onInitOpen 1  ChildProcessors   Content  Control type ScriptComboBox id cmbAttack value 	      �? Control type ScriptComboBox id cmbRelease value 	      �? Control type ScriptSlider id knbAttackUnsync value 	         Control type ScriptSlider id knbReleaseUnsync value 	         Control type ScriptSlider id knbThreshold value 	   `��0� Control type ScriptSlider id 
knbRatio value 	      4@ Control type ScriptSlider id 	knbKnee value 	   ��(�? Control type ScriptSlider id 
knbKnee1 value 	   ���? Control type ScriptSlider id knbMakeupGain value 	         Control type ScriptSlider id knbChannelLink value 	         Control type ScriptSlider id knbIn value 	         Control type ScriptSlider id knbOut value 	         UIData  ContentProperties DeviceType 	Desktop Component type ScriptPanel id InputMeter x    y    width 	      >@height 	     �f@bgColour 	�    itemColour 	g���    itemColour2 	�    textColour 	UUU�    opaque 	        Component type ScriptPanel id OutputMeter x ,  y    width 	      >@height 	     �f@bgColour 	�    itemColour 	g���    itemColour2 	�    textColour 	UUU�    opaque 	        Component type ScriptLabel id Label1 x 	        y 	     @j@width 	     �Q@height 	      4@text Input editable  Component type ScriptLabel id Label2 x 	     �q@y 	     @j@width 	     �Q@height 	      4@text Output editable  Component type ScriptPanel id Panel1 x 	      N@y 	      >@width 	     �l@height 	     �f@Component type ScriptComboBox id cmbAttack x 	      4@y 	      D@max     parentComponent Panel1 width 	      T@height 	      >@ Component type ScriptComboBox id cmbRelease x 	     @`@y 	      D@max     parentComponent Panel1 width 	      T@height 	      >@ Component type ScriptSlider id knbAttackUnsync x 	      D@y 	      Y@parentComponent Panel1 width 	      D@height 	      D@ Component type ScriptSlider id knbReleaseUnsync x 	     �b@y 	      Y@parentComponent Panel1 width 	      D@height 	      D@ Component 	type ScriptLabel id Label3 x 	      D@y 	     �a@width 	      I@height 	      4@text Unsync editable parentComponent Panel1  Component 	type ScriptLabel id Label4 x 	     �a@y 	     �a@width 	      N@height 	      4@text Unsync editable parentComponent Panel1  Component type ScriptLabel id Attack x 	      4@y 	      $@width 	      T@height 	      4@editable parentComponent Panel1  Component 	type ScriptLabel id 	Attack1 x 	     @`@y 	      $@width 	      T@height 	      4@editable parentComponent Panel1 text 	Release  Component 	type ScriptSlider id knbThreshold x 	     �u@y 	      d@width 	      D@height 	      D@min 	      X�max 	        middlePosition 	      H� Component 	type ScriptSlider id 
knbRatio x 	     �y@y 	      d@width 	      D@height 	      D@min 	      �?max 	      4@middlePosition 	      $@ Component type ScriptSlider id 	knbKnee x 	     `}@y 	      d@width 	      D@height 	      D@ Component type ScriptSlider id 
knbKnee1 x 	     ��@y 	      d@width 	      D@height 	      D@ Component type ScriptSlider id knbMakeupGain x 	      ]@y 	     @p@width 	      D@height 	      D@ Component type ScriptSlider id knbChannelLink x 	      h@y 	     @p@width 	      D@height 	      D@ Component type ScriptSlider id knbIn x 	      D@y 	     @p@width 	      D@height 	      D@ Component type ScriptSlider id knbOut x 	     �p@y 	     @p@width 	      D@height 	      D@ Processor Type ModulatorChain ID GainModulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type ModulatorChain ID PitchModulation Bypassed Intensity 	        EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type EffectChain ID FX Bypassed EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors  Processor Type SimpleGain ID Input Bypassed Gain 	        Delay 	        Width 	      Y@Balance 	        InvertPolarity 	        EditorStates BodyShown 1 Visible 1 Solo 0  ChildProcessors  Processor Type ModulatorChain ID Gain Modulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type ModulatorChain ID Delay Modulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type ModulatorChain ID Width Modulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type ModulatorChain ID Pan Modulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   RoutingMatrix NumSourceChannels    Channel0     Send0 ����Channel1    Send1 ���� Processor Type 
ScriptFX ID Script FX1 Bypassed Script � function prepareToPlay(sampleRate, blockSize)
{
	
}
 function processBlock(channels)
{
	
}
 function onControl(number, value)
{
	
}
  EditorStates BodyShown 1 Visible 1 Solo 0  ChildProcessors   RoutingMatrix NumSourceChannels    Channel0     Send0 ����Channel1    Send1 ���� Content   Networks  Network ID script_fx1 Version 0.0.0  UIData  ContentProperties DeviceType 	Desktop  Processor Type SimpleGain ID MasterOut Bypassed Gain 	        Delay 	        Width 	      Y@Balance 	        InvertPolarity 	        EditorStates BodyShown 1 Visible 1 Solo 0  ChildProcessors  Processor Type ModulatorChain ID Gain Modulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0 Folded 1  ChildProcessors   Processor Type ModulatorChain ID Delay Modulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0 Folded 1  ChildProcessors   Processor Type ModulatorChain ID Width Modulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0 Folded 1  ChildProcessors   Processor Type ModulatorChain ID Pan Modulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0 Folded 1  ChildProcessors   RoutingMatrix NumSourceChannels    Channel0     Send0 ����Channel1    Send1 ���� Processor Type WaveSynth ID Waveform Generator1 Bypassed Gain 	      �?Balance 	        VoiceLimit 	      p@KillFadeTime 	      4@IconColour 0 OctaveTranspose1 	        OctaveTranspose2 	        Detune1 	        Detune2 	        WaveForm1 	      @WaveForm2 	      @Pan1 	        Pan2 	        Mix 	      �?EnableSecondOscillator 	      �?PulseWidth1 	      �?PulseWidth2 	      �?HardSync 	        EditorStates BodyShown 1 Visible 1 Solo 0 Folded 1  ChildProcessors  Processor Type MidiProcessorChain ID Midi Processor Bypassed EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type ModulatorChain ID GainModulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors  Processor 	Type SimpleEnvelope ID DefaultEnvelope1 Bypassed Monophonic 	        Retrigger 	      �?Intensity 	      �?Attack 	      @Release 	      $@LinearMode 	      �?EditorStates BodyShown 1 Visible 1 Solo 0  ChildProcessors  Processor Type ModulatorChain ID Attack Time Modulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type ModulatorChain ID PitchModulation Bypassed Intensity 	        EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type EffectChain ID FX Bypassed EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type ModulatorChain ID Mix Modulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type ModulatorChain ID Osc2 Pitch Modulation Bypassed Intensity 	        EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   RoutingMatrix NumSourceChannels    Channel0     Send0 ����Channel1    Send1 ���� RoutingMatrix NumSourceChannels    Channel0     Send0 ����Channel1    Send1 ���� macro_controls  macro name 	Macro 1 value 	        midi_cc ���� macro name 	Macro 2 value 	        midi_cc ���� macro name 	Macro 3 value 	        midi_cc ���� macro name 	Macro 4 value 	        midi_cc ���� macro name 	Macro 5 value 	        midi_cc ���� macro name 	Macro 6 value 	        midi_cc ���� macro name 	Macro 7 value 	        midi_cc ���� macro name 	Macro 8 value 	        midi_cc ���� MidiAutomation   MPEData Enabled  