Processor 
Type SynthChain ID Preset Bypassed Gain 	      �?Balance 	        VoiceLimit 	      P@KillFadeTime 	      4@IconColour 0 packageName  BuildVersion �  EditorStates BodyShown 0 Visible 1 Solo 0 Folded 1  ChildProcessors  Processor Type MidiProcessorChain ID Midi Processor Bypassed EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors  Processor Type ScriptProcessor ID Interface Bypassed Script + Content.makeFrontInterface(590, 640);
Engine.loadFontAs("{PROJECT_FOLDER}Fonts/uni-sans.heavy-caps.otf","UnisansALLCAPS");
Engine.setGlobalFont("UnisansALLCAPS");

//const var MBStereoImager = Synth.getEffect("Script FX1");
const var MBStereoImager = Synth.getEffect("HardcodedMasterFX1");

// BANDS MANAGER
const var knobBand1 = Content.getComponent("knbBand1");
const var knobBand2 = Content.getComponent("knbBand2");
const var knobBand3 = Content.getComponent("knbBand3");

const var knbWidth1 = Content.getComponent("knbWidth1");
const var knbWidth2 = Content.getComponent("knbWidth2");
const var knbWidth3 = Content.getComponent("knbWidth3");

const var knbGain1 = Content.getComponent("knbGain1");
const var knbGain2 = Content.getComponent("knbGain2");
const var knbGain3 = Content.getComponent("knbGain3");
const var knbGain0 = Content.getComponent("knbGain0");


inline function onknobBand1Control(component, value)
{
    local band2Value = knobBand2.getValue();
    
    if(value > band2Value)
    {
        knobBand2.setValue(value);
        knobBand2.changed();
    }
    MBStereoImager.setAttribute(MBStereoImager.Band1, value);
};
knobBand1.setControlCallback(onknobBand1Control);

inline function onknobBand2Control(component, value)
{
    local band1Value = knobBand1.getValue();
    local band3Value = knobBand3.getValue();
    
    if(value < band1Value)
    {
        knobBand1.setValue(value);
        knobBand1.changed();
    }
    else if(value > band3Value)
    {
        knobBand3.setValue(value);
        knobBand3.changed();
    }
    MBStereoImager.setAttribute(MBStereoImager.Band2, value);
};
knobBand2.setControlCallback(onknobBand2Control);

inline function onknobBand3Control(component, value)
{
    local band2Value = knobBand2.getValue();
    
    if(value < band2Value)
    {
        knobBand2.setValue(value);
        knobBand2.changed();
    }
    MBStereoImager.setAttribute(MBStereoImager.Band3, value);
};
knobBand3.setControlCallback(onknobBand3Control);

// BACKGROUND - gradient
const var pnlBackground = Content.getComponent("pnlBackground");

pnlBackground.setPaintRoutine(function(g) {
    g.setGradientFill([Colours.cyan, 0, 0, Colours.cyan, 10, 0]);
    g.fillRoundedRectangle([0, 0, this.getWidth(), this.getHeight()], 15);
});

// Local LAF:
const locl_laf = Content.createLocalLookAndFeel();

//  Sliders
locl_laf.registerFunction("drawRotarySlider", function(g, obj)
{

    var K = Content.createPath();
    var p1 = Content.createPath();
    var range = obj.max - obj.min;
    
    var startOffset = 2.4;
    var arcThickness = 0.10;
    var arcWidth = 1.0 - 2.0 * arcThickness;
      
    p1.clear();

	var endOffset = -startOffset + 2.0 * startOffset * obj.valueNormalized;
    
    var val = "";

    var a = obj.area;
    var w = obj.area;
    var round = 2;
    var h = a[3];    

	g.setColour(obj.itemColour1);
	    
    g.setColour(obj.bgColour);
    p1.addArc([arcThickness / 2, arcThickness / 2, arcWidth + arcThickness, arcWidth + arcThickness], - startOffset , 2.5);
        
    var pathArea = p1.getBounds(obj.area[2]);
        
    g.setColour(obj.bgColour);
    g.drawPath(p1, pathArea, obj.area[2] * arcThickness);
    
    K.addArc([arcThickness / 2, arcThickness / 2, arcWidth + arcThickness, arcWidth + arcThickness], -startOffset - 0.08 , endOffset);   
    
    var pathArea = K.getBounds(obj.area[2]);

	var gradient = [0.0, Colours.lime, 1.0, Colours.royalblue];

	g.setGradientFill([Colours.cyan, 0, 0, Colours.lightgreen, obj.area[2], 0]);
	g.drawPath(K, pathArea, obj.area[2] * arcThickness);
    
    if (obj.hover || obj.clicked)
    {

    g.setColour(obj.textColour);	
    g.drawPath(K, pathArea, obj.area[2] * arcThickness );

    }
    g.rotate(endOffset, [obj.area[2] / 2, obj.area[2] / 2]);
    g.setColour(obj.textColour);
    g.fillRoundedRectangle([obj.area[2] / 2 - obj.area[2] * 0.04, obj.area[2] / 2 - obj.area[2] * 0.5, obj.area[2]  * 0.1, obj.area[2] * 0.13], 0);

});

knobBand1.setLocalLookAndFeel(locl_laf);
knobBand2.setLocalLookAndFeel(locl_laf);
knobBand3.setLocalLookAndFeel(locl_laf);
knbGain1.setLocalLookAndFeel(locl_laf);
knbGain2.setLocalLookAndFeel(locl_laf);
knbGain3.setLocalLookAndFeel(locl_laf);
knbGain0.setLocalLookAndFeel(locl_laf);
knbWidth1.setLocalLookAndFeel(locl_laf);
knbWidth2.setLocalLookAndFeel(locl_laf);
knbWidth3.setLocalLookAndFeel(locl_laf);

const var FloatingTile2 = Content.getComponent("FloatingTile2");
const var FloatingTile3 = Content.getComponent("FloatingTile3");
const var FloatingTile4 = Content.getComponent("FloatingTile4");

const var laf = Content.createLocalLookAndFeel();

laf.registerFunction("drawAnalyserBackground", function(g, obj)
{
	 g.fillAll(Colours.cyan);
});

laf.registerFunction("drawAnalyserGrid", function(g, obj)
{

	g.fillAll(Colours.cyan);
	
});

laf.registerFunction("drawAnalyserPath", function(g, obj)
{
	 g.setColour(Colours.white);
	 g.fillPath(obj.path, obj.area);
});
FloatingTile2.setLocalLookAndFeel(laf);
FloatingTile3.setLocalLookAndFeel(laf);
FloatingTile4.setLocalLookAndFeel(laf);

// BUTTON LAF
const var btnMono = Content.getComponent("btnMono");
var LAF_SmallToggleButton = Content.createLocalLookAndFeel();

LAF_SmallToggleButton.registerFunction("drawToggleButton", function(g, obj)
{
    g.setColour(obj.bgColour);   
    g.fillRoundedRectangle(obj.area, 4.0);
    
    if(obj.over)
        g.fillRoundedRectangle(obj.area, 4.0);
    
    if(obj.down)
        g.fillRoundedRectangle(obj.area, 4.0);
        
    g.setColour(Colours.withAlpha(obj.textColour, obj.value ? 1.0 : 0.3));
    g.setFont("UnisansALLCAPS", 12.0);
    g.drawAlignedText(obj.text, obj.area, "centred");
});

btnMono.setLocalLookAndFeel(LAF_SmallToggleButton);

// SoftPanel
const var Panel1 = Content.getComponent("Panel1");
const var Panel2 = Content.getComponent("Panel2");
const var Panel4 = Content.getComponent("Panel4");
const var Panel3 = Content.getComponent("Panel3");

Panel2.setPaintRoutine(drawSubPanel);
inline function drawSubPanel(g)
{
	local a = this.getLocalBounds(8);
	
	g.drawDropShadow(a, Colours.withAlpha(Colours.black, 0.6), 8);

	g.setColour(Colours.cyan);
	g.fillRoundedRectangle(a, this.get("borderRadius"));
}

Panel3.setPaintRoutine(drawSubPanel);
Panel4.setPaintRoutine(drawSubPanel);
Panel1.setPaintRoutine(drawSubPanel);

// == PRESET BROWSER
// Show
const var pnlPreset = Content.getComponent("pnlPreset");

inline function onbtnPresetControl(component, value)
{
	if (value == 1){
		pnlPreset.set("visible", true);	
	}	
	
	if (value == 0){
		pnlPreset.set("visible", false);
	
	}	
	
};
Content.getComponent("btnPreset").setControlCallback(onbtnPresetControl);

// === ICONS ===

// Folder Icon
const var pnlPresetIcon = Content.getComponent("pnlPresetIcon");
const var btnPreset = Content.getComponent("btnPreset");

const var svgPresetIcon = Content.createSVG("612.nT6K8C1yBTsD.XFp6UB7vwL.dIHiSLSC3nHB0gTt7.gVNyTRtIfTjj1+KbR5OC7xGOev5APc.nF.ZV4bDcFtR0BMGWzRXJYYLztfxhngTxQeFCmMwo8cccMLigenf7VKgkfxVXRztOvCAB.xSZS5myINs37mwIS.QTKphBCJaRbJK+0tuqqKFK.aai50OFPHFm+rmLAD8AQbPLFoRQL5uNRBJXfDNzSbZMBNTQDQZ3fAdDfUFNBJaK9jNVib1lV+xvUYYPQltvhLF9gIS.w6QppmjD7drrpvn6vWuGoqMxYSZDAcgist.5B2u38dmZbUYUo.5joks78TIaPGthqeSbZQoTReztrnToeye9dtxUZYXNpMopt9UASJcdOaTSUXpdhS6Q.Pbuya8I8q98c5Ep1Vem19Nv5KineysxAgRnyy3Q1uoNcpqeeFe4Y7lu51e5QyugwueC0snekRcpkWNc6u3NOiKiruS04ZdZiSYeGlIr4k2EJuGo9IQhDITaPXOZHSOZHW4npqpbFuGLnH7UU...YhSK9Pf.lhOZHwWGPmZ9KMTu4sMVM+hs5TKOisBadqsRoipr5b2eQRgKOkwsbdKj9U38cV7HmmNqNU8cnbK+cRotMrgv62PsZ96bRs7xqaeGlEmRGyuN86Sm98kt8qNyOiXbnd0Z4Dr.BTFyT3YfObOVYqnHG3XNShRiMfgGfY.o.tCBoSNmY6Bt7PWrvBBKLcQnfPE5JXtpte7.7MLWaejInoQAqcI0G.AWmJHkX8CjUluHeCfB7j7FAe8DfBbvWtVwHlzUwEccXIecmkvqmn");

pnlPresetIcon.setPaintRoutine(function(g)
{	
	g.setColour(Colours.white);
	g.drawSVG(svgPresetIcon, this.getLocalBounds(0), 1);
});

const var lafTransparent = Content.createLocalLookAndFeel();
lafTransparent.registerFunction("drawToggleButton", function(g, obj)
{
	g.setColour(obj.bgColour);   
	g.fillRoundedRectangle(obj.area, 4.0);
});
btnPreset.setLocalLookAndFeel(lafTransparent);
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
  EditorStates BodyShown 1 Visible 1 Solo 0 contentShown 1 onInitOpen 1  ChildProcessors   Content  Control type ScriptButton id 	btnMono value 	      �? Control type ScriptSlider id 
knbBand1 value 	      Y@ Control type ScriptSlider id 
knbBand2 value 	     p�@ Control type ScriptSlider id 
knbBand3 value 	     p�@ Control type ScriptSlider id knbWidth1 value 	      �? Control type ScriptSlider id knbWidth2 value 	      �? Control type ScriptSlider id knbWidth3 value 	      �? Control type ScriptSlider id 
knbGain1 value 	      �> Control type ScriptSlider id 
knbGain2 value 	      �> Control type ScriptSlider id 
knbGain3 value 	      �> Control type ScriptTable id Table1 value 	        data   Control type ScriptTable id Table2 value 	        data   Control type ScriptTable id Table3 value 	        data   Control type ScriptSlider id 
knbGain0 value 	      �> Control type ScriptButton id btnPreset value 	         UIData  ContentProperties DeviceType 	Desktop FComponent type ScriptPanel id pnlBackground x 	      $@y 	      $@width 	     Ё@height 	     ��@ Component type ScriptPanel id Panel1 x 	      4@y 	     �k@width 	     @`@height 	      d@itemColour 	���     itemColour2 	���     bgColour 	����    borderSize 	      @textColour 	���n    Component type ScriptPanel id Panel8 x 	      4@y 	      Y@width 	     �V@height 	      D@textColour 	����    itemColour 	        itemColour2 	        borderSize 	      @parentComponent Panel1  Component type ScriptButton id 	btnMono x 	      4@y 	      Y@width 	     �V@height 	      D@text Mono parentComponent Panel1 textColour 	--/�    tooltip Force Mono on Lowest Band  isPluginParameter pluginParameterName MakeItMono processorId HardcodedMasterFX1 parameterId Mono bgColour 	���@     Component type ScriptPanel id Panel2 x 	      d@y 	     �a@width 	     @`@height 	     `x@textColour 	���n    itemColour 	�� �    itemColour2 	�� �    borderSize 	      @bgColour 	�� �     Component 
type ScriptPanel id Panel3 x 	     �{@y 	     �a@width 	     @`@height 	     `x@textColour 	���n    itemColour 	        itemColour2 	        borderSize 	      @ Component 
type ScriptPanel id Panel4 x 	     �r@y 	     �a@width 	     @`@height 	     `x@textColour 	���n    itemColour 	        itemColour2 	        borderSize 	      @ Component type ScriptFloatingTile id FloatingTile2 x 	      g@y 	     �z@width 	      T@height 	      T@ContentType AudioAnalyser bgColour 	  ��    itemColour 	)�[�    itemColour2 	  ��    textColour 	   �    Data U{
  "ProcessorId": "HardcodedMasterFX1",
  "Index": 0,
  "FollowWorkspace": false
} itemColour3 	   �     Component type ScriptFloatingTile id FloatingTile3 x 	     Pt@y 	     �z@width 	      T@height 	      T@ContentType AudioAnalyser bgColour 	333�    itemColour 	����    itemColour2 	DDD�    textColour 	   �    Data U{
  "ProcessorId": "HardcodedMasterFX1",
  "Index": 1,
  "FollowWorkspace": false
} itemColour3 	   �     Component type ScriptFloatingTile id FloatingTile4 x 	     }@y 	     �z@width 	      T@height 	      T@ContentType AudioAnalyser bgColour 	333�    itemColour 	����    itemColour2 	DDD�    textColour 	   �    Data U{
  "ProcessorId": "HardcodedMasterFX1",
  "Index": 2,
  "FollowWorkspace": false
} itemColour3 	   �     Component 
type ScriptPanel id Panel5 x 	      g@y 	     �z@width 	      T@height 	      T@textColour 	���n    itemColour 	        itemColour2 	        borderSize 	      @ Component 
type ScriptPanel id Panel6 x 	     Pt@y 	     �z@width 	      T@height 	      T@textColour 	���n    itemColour 	        itemColour2 	        borderSize 	      @ Component 
type ScriptPanel id Panel7 x 	     }@y 	     �z@width 	      T@height 	      T@textColour 	���n    itemColour 	        itemColour2 	        borderSize 	      @ Component type ScriptPanel id pnlSubPanel1 x 	     �g@y 	     @u@width 	     �Q@height 	     �Q@itemColour 4285032552 itemColour2 	�� �    textColour 0 borderSize 	      "@borderRadius 	     �A@ Component type ScriptPanel id pnlSubPanel2 x 	     �g@y 	     @o@width 	     �Q@height 	     �Q@itemColour 4285032552 itemColour2 	�� �    textColour 0 borderSize 	      "@borderRadius 	     �A@ Component type ScriptPanel id pnlSubPanel3 x 	     �g@y 	     �c@width 	     �Q@height 	     �Q@itemColour 4285032552 itemColour2 	�� �    textColour 0 borderSize 	      "@borderRadius 	     �A@ Component type ScriptPanel id pnlSubPanel4 x 	     �t@y 	     @u@width 	     �Q@height 	     �Q@itemColour 4285032552 itemColour2 	�� �    textColour 0 borderSize 	      "@borderRadius 	     �A@ Component type ScriptPanel id pnlSubPanel5 x 	     �t@y 	     @o@width 	     �Q@height 	     �Q@itemColour 4285032552 itemColour2 	�� �    textColour 0 borderSize 	      "@borderRadius 	     �A@ Component type ScriptPanel id pnlSubPanel6 x 	     �t@y 	     `c@width 	     �Q@height 	     �Q@itemColour 4285032552 itemColour2 	�� �    textColour 0 borderSize 	      "@borderRadius 	     �A@ Component type ScriptPanel id pnlSubPanel7 x 	     `}@y 	     �c@width 	     �Q@height 	     �Q@itemColour 4285032552 itemColour2 	�� �    textColour 0 borderSize 	      "@borderRadius 	     �A@ Component type ScriptPanel id pnlSubPanel8 x 	      I@y 	     �l@width 	     �Q@height 	     �Q@itemColour 4285032552 itemColour2 	�� �    textColour 0 borderSize 	      "@borderRadius 	     �A@ Component type ScriptPanel id pnlSubPanel9 x 	     `}@y 	     @o@width 	     �Q@height 	     �Q@itemColour 4285032552 itemColour2 	�� �    textColour 0 borderSize 	      "@borderRadius 	     �A@ Component type ScriptPanel id pnlSubPanel10 x 	     `}@y 	     @u@width 	     �Q@height 	     �Q@itemColour 4285032552 itemColour2 	�� �    textColour 0 borderSize 	      "@borderRadius 	     �A@ Component type ScriptPanel id 	PanelBG x 	      i@y 	     �d@width 	      I@height 	      I@itemColour 4285032552 itemColour2 	�� �    textColour     borderSize 	      "@borderRadius 	      4@ Component type ScriptPanel id 
PanelBG1 x 	      i@y 	     @p@width 	      I@height 	      I@itemColour 4285032552 itemColour2 	�� �    textColour     borderSize 	      "@borderRadius 	      4@ Component type ScriptPanel id 
PanelBG2 x 	      i@y 	     �u@width 	      I@height 	      I@itemColour 4285032552 itemColour2 	�� �    textColour     borderSize 	      "@borderRadius 	      4@ Component type ScriptPanel id 
PanelBG3 x 	     @u@y 	     �u@width 	      I@height 	      I@itemColour 4285032552 itemColour2 	�� �    textColour     borderSize 	      "@borderRadius 	      4@ Component type ScriptPanel id 
PanelBG4 x 	     @u@y 	     @p@width 	      I@height 	      I@itemColour 4285032552 itemColour2 	�� �    textColour     borderSize 	      "@borderRadius 	      4@ Component type ScriptPanel id 
PanelBG5 x 	     @u@y 	     �d@width 	      I@height 	      I@itemColour 4285032552 itemColour2 	�� �    textColour     borderSize 	      "@borderRadius 	      4@ Component type ScriptPanel id 
PanelBG6 x 	      ~@y 	     �d@width 	      I@height 	      I@itemColour 4285032552 itemColour2 	�� �    textColour     borderSize 	      "@borderRadius 	      4@ Component type ScriptPanel id 
PanelBG7 x 	      ~@y 	     @p@width 	      I@height 	      I@itemColour 4285032552 itemColour2 	�� �    textColour     borderSize 	      "@borderRadius 	      4@ Component type ScriptPanel id 
PanelBG8 x 	      ~@y 	     �u@width 	      I@height 	      I@itemColour 4285032552 itemColour2 	�� �    textColour     borderSize 	      "@borderRadius 	      4@ Component type ScriptPanel id 
PanelBG9 x 	      N@y 	      n@width 	      I@height 	      I@itemColour 4285032552 itemColour2 	�� �    textColour     borderSize 	      "@borderRadius 	      4@ Component 
type ScriptPanel id PanelAbove x 	     `j@y 	     �e@width 	      >@height 	      >@itemColour 	�� �    itemColour2 4283847250 borderSize 	      �?borderRadius 	      4@ Component 
type ScriptPanel id PanelAbove1 x 	     @j@y 	     �p@width 	      >@height 	      >@itemColour 	�� �    itemColour2 4283847250 borderSize 	      �?borderRadius 	      4@ Component 
type ScriptPanel id PanelAbove2 x 	     @j@y 	     �v@width 	      >@height 	      >@itemColour 	�� �    itemColour2 4283847250 borderSize 	      �?borderRadius 	      4@ Component 
type ScriptPanel id PanelAbove3 x 	     �u@y 	     �v@width 	      >@height 	      >@itemColour 	�� �    itemColour2 4283847250 borderSize 	      �?borderRadius 	      4@ Component 
type ScriptPanel id PanelAbove4 x 	     �u@y 	     �p@width 	      >@height 	      >@itemColour 	�� �    itemColour2 4283847250 borderSize 	      �?borderRadius 	      4@ Component 
type ScriptPanel id PanelAbove5 x 	     �u@y 	      f@width 	      >@height 	      >@itemColour 	�� �    itemColour2 4283847250 borderSize 	      �?borderRadius 	      4@ Component 
type ScriptPanel id PanelAbove6 x 	     �~@y 	      f@width 	      >@height 	      >@itemColour 	�� �    itemColour2 4283847250 borderSize 	      �?borderRadius 	      4@ Component 
type ScriptPanel id PanelAbove7 x 	     �~@y 	     �p@width 	      >@height 	      >@itemColour 	�� �    itemColour2 4283847250 borderSize 	      �?borderRadius 	      4@ Component 
type ScriptPanel id PanelAbove8 x 	     �~@y 	     �v@width 	      >@height 	      >@itemColour 	�� �    itemColour2 4283847250 borderSize 	      �?borderRadius 	      4@ Component 
type ScriptPanel id PanelAbove9 x 	     �Q@y 	     @o@width 	      >@height 	      >@itemColour 	�� �    itemColour2 4283847250 borderSize 	      �?borderRadius 	      4@ Component type ScriptSlider id 
knbBand1 x 	      i@y 	     �d@width 	      I@height 	      I@mode Frequency min 	      4@max 	     ��@stepSize 	      �?suffix  Hz middlePosition 	     p�@defaultValue 	      Y@tooltip Frequency Range showValuePopup Left showTextBox isPluginParameter pluginParameterName Band1  Component type ScriptSlider id 
knbBand2 x 	     @u@y 	     �d@width 	      I@height 	      I@mode Frequency min 	      4@max 	     ��@stepSize 	      �?suffix  Hz middlePosition 	     p�@defaultValue 	     p�@tooltip Frequency Range showValuePopup Left showTextBox isPluginParameter pluginParameterName Band2  Component type ScriptSlider id 
knbBand3 x 	      ~@y 	     �d@width 	      I@height 	      I@mode Frequency min 	      4@max 	     ��@stepSize 	      �?suffix  Hz middlePosition 	     p�@defaultValue 	     p�@tooltip Frequency Range showValuePopup Left showTextBox isPluginParameter pluginParameterName Band3  Component 	type ScriptLabel id Label1 x 	      d@y 	     �j@text Band 1 fontName UnisansALLCAPS fontSize 	      0@textColour 	--/�    editable  Component 	type ScriptLabel id Label2 x 	     �r@y 	     �j@text Band 2 fontName UnisansALLCAPS fontSize 	      0@textColour 	--/�    editable  Component 	type ScriptLabel id Label3 x 	     �{@y 	     �j@text Band 3 fontName UnisansALLCAPS fontSize 	      0@textColour 	--/�    editable  Component type ScriptSlider id knbWidth1 x 	      i@y 	     @p@width 	      I@height 	      I@mode NormalizedPercentage suffix % middlePosition 	      �?max 	       @defaultValue 	      �?tooltip Stereo Width showValuePopup Left showTextBox isPluginParameter pluginParameterName Width1 processorId HardcodedMasterFX1 parameterId Width1  Component type ScriptSlider id knbWidth2 x 	     @u@y 	     @p@width 	      I@height 	      I@mode NormalizedPercentage suffix % middlePosition 	      �?max 	       @defaultValue 	      �?tooltip Stereo Width showValuePopup Left showTextBox isPluginParameter pluginParameterName Width2 processorId HardcodedMasterFX1 parameterId Width2  Component type ScriptSlider id knbWidth3 x 	      ~@y 	     @p@width 	      I@height 	      I@mode NormalizedPercentage suffix % middlePosition 	      �?max 	       @defaultValue 	      �?tooltip Stereo Width showValuePopup Left showTextBox isPluginParameter pluginParameterName Width3 processorId HardcodedMasterFX1 parameterId Width3  Component 	type ScriptLabel id Label4 x 	      d@y 	     `s@text Width fontName UnisansALLCAPS fontSize 	      0@textColour 	--/�    editable  Component 	type ScriptLabel id Label5 x 	     �r@y 	     `s@text Width fontName UnisansALLCAPS fontSize 	      0@textColour 	--/�    editable  Component 	type ScriptLabel id Label6 x 	     �{@y 	     `s@text Width fontName UnisansALLCAPS fontSize 	      0@textColour 	--/�    editable  Component type ScriptSlider id 
knbGain1 x 	      i@y 	     �u@width 	      I@height 	      I@mode 	Decibel min 	      N�max 	      2@stepSize 	   ����?suffix  dB middlePosition 	        tooltip Band 1 Gain showValuePopup Left showTextBox isPluginParameter pluginParameterName Gain1 processorId HardcodedMasterFX1 parameterId Gain1  Component 	type ScriptLabel id Label7 x 	      d@y 	      y@text Gain fontName UnisansALLCAPS fontSize 	      0@textColour 	--/�    editable  Component 	type ScriptLabel id Label8 x 	     �r@y 	      y@text Gain fontName UnisansALLCAPS fontSize 	      0@textColour 	--/�    editable  Component 	type ScriptLabel id Label9 x 	     �{@y 	      y@text Gain fontName UnisansALLCAPS fontSize 	      0@textColour 	--/�    editable  Component type ScriptSlider id 
knbGain2 x 	     @u@y 	     �u@width 	      I@height 	      I@text 
knbGain1 mode 	Decibel min 	      N�max 	      2@stepSize 	   ����?suffix  dB middlePosition 	        tooltip Band 2 Gain showValuePopup Left showTextBox isPluginParameter pluginParameterName Gain2 processorId HardcodedMasterFX1 parameterId Gain2  Component type ScriptSlider id 
knbGain3 x 	      ~@y 	     �u@width 	      I@height 	      I@text 
knbGain1 mode 	Decibel min 	      N�max 	      2@stepSize 	   ����?suffix  dB middlePosition 	        tooltip Band 3 Gain showValuePopup Left showTextBox isPluginParameter processorId HardcodedMasterFX1 parameterId Gain3  Component type ScriptTable id Table1 x 	      4@y 	      4@width 	     0�@height 	      Y@customColours itemColour2 	     itemColour 	333     bgColour 	���     processorId HardcodedMasterFX1  Component type ScriptTable id Table2 x 	      4@y 	      4@width 	     0�@height 	      Y@customColours itemColour2 	     itemColour 	333     bgColour 	���     processorId HardcodedMasterFX1 tableIndex 1  Component type ScriptTable id Table3 x 	      4@y 	      4@width 	     0�@height 	      Y@customColours itemColour2 	     itemColour 	333     bgColour 	���     processorId HardcodedMasterFX1 tableIndex 2  Component type ScriptSlider id 
knbGain0 x 	      N@y 	      n@width 	      I@height 	      I@mode 	Decibel min 	      N�max 	      2@stepSize 	   ����?suffix  dB middlePosition 	        tooltip Lowest Band Gain showValuePopup Left showTextBox isPluginParameter pluginParameterName GainLowFreq processorId HardcodedMasterFX1  Component type ScriptLabel id 	Label10 x 	      4@y 	      r@text Gain fontName UnisansALLCAPS textColour 	--/�    editable  Component type ScriptFloatingTile id FloatingTile1 x 	      4@y 	      4@width 	     0�@height 	      Y@ContentType AudioAnalyser bgColour 	333     itemColour 	���]    itemColour2 	DDD     textColour 	        Data L{
  "ProcessorId": "Analyser1",
  "Index": 2,
  "FollowWorkspace": false
}  Component type ScriptLabel id 	Label11 x 	      w@y 	      �@width 	     @j@height 	      I@text 	RESPIRO fontSize 	      G@alignment right fontName UnisansALLCAPS editable  Component type ScriptFloatingTile id FloatingTile5 x 	      4@y 	     ��@width 	     0�@height 	      >@ContentType TooltipPanel bgColour 	888�    itemColour 	���    itemColour2 	        textColour 	����     Component type ScriptPanel id pnlPresetIcon x 	      >@y 	      �@width 	      D@height 	      D@ Component type ScriptButton id btnPreset x 	      >@y 	      �@width 	      D@height 	      D@bgColour 	���     tooltip Show/Hide Preset Browser  Component 	type ScriptPanel id pnlPreset x 	      $@y 	      $@width 	     Ё@height 	     ��@itemColour 	   �    itemColour2 	   �    visible     Component type ScriptFloatingTile id FloatingTile6 x 	      $@y 	      $@parentComponent pnlPreset width 	     0�@height 	     �@ContentType PresetBrowser bgColour 	   �    itemColour 	�� �    itemColour2 	        Data �{
  "ShowSaveButton": true,
  "ShowExpansionsAsColumn": false,
  "ShowFolderButton": false,
  "ShowNotes": false,
  "ShowEditButtons": true,
  "EditButtonOffset": 10,
  "ShowAddButton": true,
  "ShowRenameButton": true,
  "ShowDeleteButton": true,
  "ShowFavoriteIcon": false,
  "ButtonsInsideBorder": false,
  "NumColumns": 2,
  "ColumnWidthRatio": [
    0.3333333333333333,
    0.3333333333333333,
    0.3333333333333333
  ],
  "ListAreaOffset": [
    0,
    0,
    0,
    0
  ],
  "ColumnRowPadding": [
    0,
    0,
    0,
    0
  ],
  "SearchBarBounds": [],
  "MoreButtonBounds": [],
  "SaveButtonBounds": [],
  "FavoriteButtonBounds": []
} Font UnisansALLCAPS  Processor Type ModulatorChain ID GainModulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type ModulatorChain ID PitchModulation Bypassed Intensity 	        EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type EffectChain ID FX Bypassed EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors  Processor Type Hardcoded Master FX ID HardcodedMasterFX1 Bypassed Network script_fx1 Band1 	      Y@Band2 	     p�@Band3 	     p�@Width1 	      �?Width2 	      �?Width3 	      �?Gain1 	      �>Gain2 	      �>Gain3 	      �>Mono 	      �?Gain0 	        EditorStates BodyShown 1 Visible 1 Solo 0  ChildProcessors   RoutingMatrix NumSourceChannels    Channel0     Send0 ����Channel1    Send1 ���� Tables  Table EmbeddedData   Table EmbeddedData   Table EmbeddedData   Processor Type 
Analyser ID Analyser1 Bypassed BufferSize 	      �@PreviewType 	      @EditorStates BodyShown 1 Visible 1 Solo 0  ChildProcessors   RoutingMatrix NumSourceChannels    Channel0     Send0 ����Channel1    Send1 ���� RoutingMatrix NumSourceChannels    Channel0     Send0 ����Channel1    Send1 ���� macro_controls  macro name 	Macro 1 value 	        midi_cc ���� macro name 	Macro 2 value 	        midi_cc ���� macro name 	Macro 3 value 	        midi_cc ���� macro name 	Macro 4 value 	        midi_cc ���� macro name 	Macro 5 value 	        midi_cc ���� macro name 	Macro 6 value 	        midi_cc ���� macro name 	Macro 7 value 	        midi_cc ���� macro name 	Macro 8 value 	        midi_cc ���� MidiAutomation   MPEData Enabled  