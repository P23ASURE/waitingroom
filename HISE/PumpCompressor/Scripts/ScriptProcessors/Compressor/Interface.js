Content.makeFrontInterface(550, 350);
Settings.setZoomLevel(1.0);

Engine.loadFontAs("{PROJECT_FOLDER}Fonts/uni-sans.heavy-caps.otf","UnisansALLCAPS");
Engine.setGlobalFont("UnisansALLCAPS");

// User Preset Handler
const var lblPreset = Content.getComponent("lblPreset");
lblPreset.set("text", "");
reg currentPreset;
const uph = Engine.createUserPresetHandler();

uph.setPostCallback(function(presetFile)
{
    currentPreset = presetFile;    
    lblPreset.set("text", Engine.getCurrentUserPresetName());
});

// Save Preset
//const var btnSavePreset = Content.getComponent("btnSavePreset");

const var knbThreshold = Content.getComponent("knbThreshold");
const var knbRatio = Content.getComponent("knbRatio");
const var knbMakeupGain = Content.getComponent("knbMakeupGain");
const var knbChannelLink = Content.getComponent("knbChannelLink");
const var knbKnee = Content.getComponent("knbKnee");
const var knbMix = Content.getComponent("knbMix");

const var knbAttackUnsync = Content.getComponent("knbAttackUnsync");
const var knbReleaseUnsync = Content.getComponent("knbReleaseUnsync");

//const var CompressorDSP = Synth.getEffect("Script FX1");
const var CompressorDSP = Synth.getEffect("HardcodedMasterFX1");

const var cmbAttack = Content.getComponent("cmbAttack");
const var cmbRelease = Content.getComponent("cmbRelease");
const var lblAttack = Content.getComponent("lblAttack");
const var lblRelease = Content.getComponent("lblRelease");
const var lblBPM = Content.getComponent("lblBPM");

// Array of note values corresponding to combo box indices
const var noteValues = [
    "1/1", "1/2D", "1/2", "1/2T", "1/4D", "1/4", "1/4T", "1/8D", "1/8", "1/8T",
    "1/16D", "1/16", "1/16T", "1/32D", "1/32", "1/32T", "1/64D", "1/64", "1/64T",
    "1/128D", "1/128", "1/128T", "1/256D", "1/256", "1/256T", "1/512D", "1/512", "1/512T"
];

function calculateTimeValue(noteValue, bpm)
{
    var ms_per_beat = 60000 / bpm;
    var ms_per_measure = ms_per_beat * 4;
    
    switch(noteValue)
    {
        case "1/1": return ms_per_measure;
        case "1/2D": return ms_per_measure * 0.75;
        case "1/2": return ms_per_measure * 0.5;
        case "1/2T": return ms_per_measure * (1/3);
        case "1/4D": return ms_per_beat * 1.5;
        case "1/4": return ms_per_beat;
        case "1/4T": return ms_per_beat * (2/3);
        case "1/8D": return ms_per_beat * 0.75;
        case "1/8": return ms_per_beat * 0.5;
        case "1/8T": return ms_per_beat * (1/3);
        case "1/16D": return ms_per_beat * 0.375;
        case "1/16": return ms_per_beat * 0.25;
        case "1/16T": return ms_per_beat * (1/6);
        case "1/32D": return ms_per_beat * 0.1875;
        case "1/32": return ms_per_beat * 0.125;
        case "1/32T": return ms_per_beat * (1/12);
        case "1/64D": return ms_per_beat * 0.09375;
        case "1/64": return ms_per_beat * 0.0625;
        case "1/64T": return ms_per_beat * (1/24);
        case "1/128D": return ms_per_beat * 0.046875;
        case "1/128": return ms_per_beat * 0.03125;
        case "1/128T": return ms_per_beat * (1/48);
        case "1/256D": return ms_per_beat * 0.0234375;
        case "1/256": return ms_per_beat * 0.015625;
        case "1/256T": return ms_per_beat * (1/96);
        case "1/512D": return ms_per_beat * 0.01171875;
        case "1/512": return ms_per_beat * 0.0078125;
        case "1/512T": return ms_per_beat * (1/192);
        default: return 0;
    }
}

var bpm;
function roundToTwoDecimals(value)
{
    return Math.round(value * 100) / 100; 
}

inline function updateLabels() {
	
    bpm = Engine.getHostBpm();
    lblBPM.set("text", bpm + " BPM");
    
    reg attackValue;
    reg releaseValue;
    reg attackTime;
    reg releaseTime;
    
    // Ricalcoliamo i tempi basati sui BPM e gli indici attuali delle combo box
    attackValue = cmbAttack.getValue();
    releaseValue = cmbRelease.getValue();

    attackTime = calculateTimeValue(noteValues[attackValue - 1], bpm);
    releaseTime = calculateTimeValue(noteValues[releaseValue - 1], bpm);

    // Arrotonda i valori dei tempi a 2 decimali
    attackTime = roundToTwoDecimals(attackTime);
    releaseTime = roundToTwoDecimals(releaseTime);

    lblAttack.set("text", attackTime + " ms");
    lblRelease.set("text", releaseTime + " ms");
}

inline function oncmbAttackControl(component, value)
{
    updateLabels(); // Aggiorna l'etichetta in base al nuovo valore
    CompressorDSP.setAttribute(CompressorDSP.Attack, value - 1);
}

inline function oncmbReleaseControl(component, value)
{
    updateLabels(); // Aggiorna l'etichetta in base al nuovo valore
    CompressorDSP.setAttribute(CompressorDSP.Release, value - 1);
}

Content.getComponent("cmbAttack").setControlCallback(oncmbAttackControl);
Content.getComponent("cmbRelease").setControlCallback(oncmbReleaseControl);

// Callback per il cambio di tempo
const TH = Engine.createTransportHandler();
inline function tempoChange(newTempo)
{
    updateLabels(); // Aggiorna le etichette su cambio di tempo
}
TH.setOnTempoChange(SyncNotification, tempoChange);

// Impostiamo il BPM iniziale
updateLabels();

// GAIN REDUCTION
const var rm = Engine.getGlobalRoutingManager();
const var GainLeft = rm.getCable("GainLeft");
const var GainRight = rm.getCable("GainRight");

const var pnlGRL = Content.getComponent("pnlGRL"); // Panel for Left Channel
const var pnlGRR = Content.getComponent("pnlGRR"); // Panel for Right Channel

// Update Gain Reduction for Left Channel
GainLeft.registerCallback(function (value)
{
    pnlGRL.data.value = value; // Store gain reduction value for left channel
    pnlGRL.repaint(); // Redraw the left channel panel
}, AsyncNotification);

// Update Gain Reduction for Right Channel
GainRight.registerCallback(function (value)
{
    pnlGRR.data.value = value; // Store gain reduction value for right channel
    pnlGRR.repaint(); // Redraw the right channel panel
}, AsyncNotification);

pnlGRL.setPaintRoutine(function(g)
{
    g.fillAll(0x22FFFFFF); // Background color with transparency
    g.setColour(0xFFffe467); // Color of the gain reduction meter

    var valueL = isDefined(this.data.value) ? Math.abs(this.data.value) : 0;
    var meterHeight = this.getHeight() * valueL;

    // Draw Down-Top Gain Reduction Meter
    g.fillRect([0, this.getHeight() - meterHeight, this.getWidth(), meterHeight]);
});

pnlGRR.setPaintRoutine(function(g)
{
    g.fillAll(0x22FFFFFF); // Background color with transparency
    g.setColour(0xFFffe467); // Color of the gain reduction meter
    
    var valueR = isDefined(this.data.value) ? Math.abs(this.data.value) : 0;
    var meterHeightR = this.getHeight() * valueR;

    // Disegna il Gain Reduction Meter dal basso verso l'alto
    g.fillRect([0, this.getHeight() - meterHeightR, this.getWidth(), meterHeightR]);
});

// Peak Meter
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
		//"itemColour": 0xFFffe467,     
		//"itemColour2": 4279505940,
		//"bgColour": 0x22FFFFFF,
		//"textColour": 4283782485,
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

const var InputMeter = VuMeter.createVuMeter("InputMeter", 10,40);
VuMeter.setModule(InputMeter, Synth.getEffect("Input"));

const var OutputMeter = VuMeter.createVuMeter("OutputMeter", 80, 40);
VuMeter.setModule(OutputMeter, Synth.getEffect("MasterOut"));;

// ========================= SOFT PANEL =================================;

const var Panel1 = Content.getComponent("Panel1");

Panel1.setPaintRoutine(drawSubPanel);
inline function drawSubPanel(g)
{
	local a = this.getLocalBounds(10);
	
	g.drawDropShadow(a, Colours.withAlpha(Colours.black, 0.6), 10);
	
	a = this.getLocalBounds(5);
	
	g.setColour(this.get("bgColour"));
	g.fillRoundedRectangle(a, this.get("borderRadius"));
}

// ========================= KNOB LAF =======================================
Content.setPropertiesFromJSON("PanelBG", {
    "width": 50.0,
    "height": 50.0,
    //"itemColour": 4285032552,
    //"itemColour2": 4278190080,
    "borderRadius": 20.0,
    "borderSize": 9.0,
    "textColour": 0
});

// const var PanelAbove = Content.addPanel("PanelAbove", 280, 160);
Content.setPropertiesFromJSON("PanelAbove", {
    "width": 30.0,
    "height": 30.0,
    //"itemColour": 4278190080,
    //"itemColour2": 4283847250,
    "borderSize": 1.0,
    "borderRadius": 20.0
});

// Local LAF
const locl_laf = Content.createLocalLookAndFeel();
const locl_laf2 = Content.createLocalLookAndFeel();

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
    
// Label Text
	g.setColour(obj.itemColour1);
	    
    g.setColour(obj.bgColour);
    p1.addArc([arcThickness / 2, arcThickness / 2, arcWidth + arcThickness, arcWidth + arcThickness], - startOffset , 2.5);
        
    var pathArea = p1.getBounds(obj.area[2]);
        
    g.setColour(obj.bgColour);
    g.drawPath(p1, pathArea, obj.area[2] * arcThickness);
    
    K.addArc([arcThickness / 2, arcThickness / 2, arcWidth + arcThickness, arcWidth + arcThickness], -startOffset - 0.08 , endOffset);   
    
    var pathArea = K.getBounds(obj.area[2]);

    g.setColour(obj.itemColour2);
    g.drawPath(K, pathArea, obj.area[2] * arcThickness );
    
    if (obj.hover || obj.clicked)
    {

    g.setColour(obj.textColour);	
    g.drawPath(K, pathArea, obj.area[2] * arcThickness );

    }
    
    g.rotate(endOffset, [obj.area[2] / 2, obj.area[2] / 2]);
    g.setColour(obj.textColour);
    g.fillRoundedRectangle([obj.area[2] / 2 - obj.area[2] * 0.04, obj.area[2] / 2 - obj.area[2] * 0.5, obj.area[2]  * 0.1, obj.area[2] * 0.13], 0);

});
knbMakeupGain.setLocalLookAndFeel(locl_laf);
knbChannelLink.setLocalLookAndFeel(locl_laf);
knbRatio.setLocalLookAndFeel(locl_laf);
knbThreshold.setLocalLookAndFeel(locl_laf);
knbKnee.setLocalLookAndFeel(locl_laf);
knbMix.setLocalLookAndFeel(locl_laf);
knbAttackUnsync.setLocalLookAndFeel(locl_laf2);
knbReleaseUnsync.setLocalLookAndFeel(locl_laf2);

var p2 = Content.createPath();
locl_laf2.registerFunction("drawRotarySlider", function(g, obj)
{
    var range = obj.max - obj.min;
    
    // start radian
    var startOffset = 2.5;
    
    var arcThickness = 0.10;
    var arcWidth = 1.0 - 2.0 * arcThickness;
    
    // Make sure you reset the path!
    p2.clear();
    
    // calculate the end radian from the current value
    var endOffset = -startOffset + 2.0 * startOffset * (obj.value - obj.min)/range;
    
    var val = "";
    
    //  Check if obj.text == "Pan"
    if (obj.text == "Unsync")
    {
        p2.addArc([arcThickness / 2, arcThickness / 2, arcWidth + arcThickness, arcWidth + arcThickness], 0, endOffset);
        
    }   
    
    var pathArea = p2.getBounds(obj.area[2]);
    
    g.setColour(obj.bgColour);
    g.fillEllipse(obj.area);
    g.setColour(obj.itemColour2);
    g.drawPath(p2, pathArea, obj.area[2] * arcThickness);
    g.setColour(obj.itemColour2);
    g.drawAlignedText(val, obj.area, "centred");
    
    
    //  Pointer
    g.beginLayer(true);
    g.rotate(endOffset, [obj.area[2] / 2, obj.area[2] / 2]);
    g.setColour(obj.textColour);
    g.fillRoundedRectangle([obj.area[2] / 2 - obj.area[2] * 0.04, obj.area[2] / 2 - obj.area[2] * 0.5, obj.area[2] * 0.1, obj.area[2] * 0.13], 0);
    g.endLayer();
    
});

// Panel Value
const var pnlDisplayPopup = Content.getComponent("pnlDisplayPopup");
const var lblDisplayValue = Content.getComponent("lblDisplayValue");

const var grpKnobs = [Content.getComponent("knbMakeupGain"),
                      Content.getComponent("knbChannelLink"),
                      Content.getComponent("knbRatio"),
                      Content.getComponent("knbThreshold"),
                      Content.getComponent("knbKnee"),
                      Content.getComponent("knbAttackUnsync"),
                      Content.getComponent("knbReleaseUnsync"),
                      Content.getComponent("knbMix")];

const var castDisplayPopup = Engine.createBroadcaster(
{
  "id": "Values Displayer",
  "args": ["component", "event"]
});

castDisplayPopup.attachToComponentMouseEvents(grpKnobs, "Clicks, Hover & Dragging", "Displays Knobs values in a popup");
castDisplayPopup.addListener("MouseUpFunction", "Displays Knobs values in a popup",

function(component, event)
{   	
    var knobIndex = grpKnobs.indexOf(component);
    var valueToDisplay = component.getValue();
    var xPos = component.get("x") + 10;
    var yPos = component.get("y") - pnlDisplayPopup.get("height") / -2.5;

    if (component == Content.getComponent("knbMakeupGain") || 
             component == Content.getComponent("knbChannelLink") ||
             component == Content.getComponent("knbRatio") ||
             component == Content.getComponent("knbThreshold") ||
             component == Content.getComponent("knbKnee") ||
             component == Content.getComponent("knbMix"))
             
    {
        pnlDisplayPopup.showControl(event.hover || event.drag);
        
        if (event.hover || event.drag)
        {
            pnlDisplayPopup.setPosition(xPos, yPos, pnlDisplayPopup.get("width"), pnlDisplayPopup.get("height"));
            lblDisplayValue.set("text", DisplayValuesOnHover(component, knobIndex));
        }
    }
    else if  (component == Content.getComponent("knbAttackUnsync") || 
             component == Content.getComponent("knbReleaseUnsync"))
             
    {
		xPos = component.get("x") +5; 
		yPos = component.get("y") - pnlDisplayPopup.get("height") / -3.5; 
        pnlDisplayPopup.showControl(event.hover || event.drag);
        
        if (event.hover || event.drag)
        {
            pnlDisplayPopup.setPosition(xPos, yPos, pnlDisplayPopup.get("width"), pnlDisplayPopup.get("height"));
            lblDisplayValue.set("text", DisplayValuesOnHover(component, knobIndex));
        }
    }
    else
    {
        // Hide both panels if no matching component is found (safety measure)
        pnlDisplayPopup.showControl(false);
    }
});

castDisplayPopup.setEnableQueue(true);


inline function DisplayValuesOnHover(component, index)
{
	local output = 0.0;

	if(component.get("suffix") == " ms")
		output = component.getValue() < 1000.0 ? (Math.round(component.getValue()) + " ms") : (Engine.doubleToString(component.getValue() / 1000.0, 2.0) + " s");
	else if(component.get("suffix") == " s")
		output = (Engine.doubleToString(component.getValue(), 1.0) + " s");
	else if(component.get("suffix") == " Hz")
		output = component.getValue() < 1000.0 ? (Math.round(component.getValue()) + " Hz") : (Engine.doubleToString(component.getValue() / 1000.0, 2.0) + " kHz");
	else if(component.get("suffix") == " dB")
		output = (Engine.doubleToString(component.getValue(), 1.0) + " dB");
	else if(component.get("suffix") == "%")
		output = (Math.round(component.getValue()*100.0) + " %");
	else if(component.get("suffix") == "Tempo")
		output = Engine.getTempoName(component.getValue());
	else if(component.get("suffix") == "st")
		output = (Engine.doubleToString(component.getValue(), 1.0) + " st");
	else if(component.get("suffix") == "Balance")
		output = (50.0 - (Math.round(component.getValue()*50.0))) + "% / " + (50.0 + (Math.round(component.getValue()*50.0))) + "%";
	else
		output = (Engine.doubleToString(component.getValue(), 1.0));

	return output;   
}

// LAF ComboBox
const LAFcmb = Content.createLocalLookAndFeel();

// Registra una funzione per disegnare il ComboBox
LAFcmb.registerFunction("drawComboBox", function(g, obj)
{
    // Colore di sfondo del ComboBox
    g.setColour(obj.bgColour);
    g.fillRoundedRectangle(obj.area, 0.0); // Angoli arrotondati
    
    // Imposta il colore del testo, riducendo l'opacità se non è abilitato o attivo
    g.setColour(Colours.withAlpha(obj.textColour, (obj.enabled && obj.active) ? 1.0 : 0.2));
    
    // Imposta il font del testo
    g.setFont("Uni Sans CAPS", 14);
    
    // Ottieni l'area del ComboBox
    var a = obj.area;
    
    // Disegna il testo allineato a sinistra, con un padding di 10 pixel
    g.drawAlignedText(obj.text, [a[0] + 10, a[1], a[2] - 10, a[3]], "left");
    
    // Disegna una freccia triangolare per indicare il menu a discesa
    var h = a[3];
    g.fillTriangle([a[0] + a[2] - h / 3 - 10, a[1] + h / 3, h / 3, h / 3], Math.PI);
});

// Applica il Look and Feel personalizzato al ComboBox
cmbAttack.setLocalLookAndFeel(LAFcmb);
cmbRelease.setLocalLookAndFeel(LAFcmb);

// == PRESET BROWSER
// Save
const var btnSavePreset = Content.getComponent("btnSavePreset");


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

const var svgPresetIcon = Content.createSVG("614.nT6K8CF3BTtD.XIJ7UB7vwL.dIHyHloAbTCGjK7IVOjPphsT1lwJaR6+C2j9y.u7mGOe5Avc.nF.M2UVljdKWwZgViI8TlxVlEbXQaR5EJYRelVdixi6+995kLs7CDj00S4onrKsHZ2E3I.GOfScS+bR4wEm+LFQBHhbRVUZQaQhTaYe86+99hQBz55pfMjgChw4O6HR.QafDChQH0IhQG1PRPgBhvglxiqOvAJj.oACD3YDJ8sr01VDDpIUjokeHhDP.glrZpm.b7HiQ1VGWCuVlCP.gAfPWWVVzeYLHzDVFYaTXHEMwyWShvxMLhw3IFXVWUHfNaZYKgPUxJ3Ka40PJOtnTJoPbXWTpzv4OgPXYVbaYuptIquFVQSJcfPcUTV4plxi6wwC2+WeR+piemlopu02ouuyR8kRz2hqdKKxEmuwktusN8Jri+Fm4ab6W86Oco4aab7ao9E8qTpWw7xoeeF24aboz8cptm8oVu59NMyE6KwLTfPSUcQZO8Cpm9AVljElU1EPHsHoLl00VVJZqK..On73hOA3fJ9zOhvMV7p4yXot8u1K6ybqdEy2bqK1+dqT1nJqtG9YjzElm13WN+cg90E76v3RNOcV8p56P8Xd7jVg6kdYA+V5k8wyYEyKw98cZXbJaL+5zwOc53W52u5M+Tpwg506kS.Kf.kALVdGHCywJXEEwANtyjH0XKXH.X.P.f6fP5jyYZWvKOfEKrfbgoMBOHTSWA8U0EimP1JJAMiBQNMMrvkTdfLdcpfThvOpMeGBxH81MIObHWOAn.e4K+qXDW5pfhtttjutyR3UQT.");

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

// SCALE GUI
namespace ZoomHandler
{
	const var MIN_ZOOM = 0.85;
	const var MAX_ZOOM = 2.0;
	const var ZOOM_STEP = 0.1;
	const var INTERFACE_WIDTH = 550;
	const var INTERFACE_HEIGHT = 350;

	const var ZoomPanel = Content.getComponent("ZoomPanel");
	
	const var draggerData = [ 110,109,143,130,218,67,147,216,145,66,108,147,216,145,66,143,130,218,67,108,0,0,0,0,143,130,218,67,108,143,130,218,67,0,0,0,0,108,143,130,218,67,147,216,145,66,99,109,143,130,218,67,139,140,96,67,108,139,140,96,67,143,130,218,67,108,66,160,23,67,143,
	130,218,67,108,143,130,218,67,66,160,23,67,108,143,130,218,67,139,140,96,67,99,109,143,130,218,67,102,22,188,67,108,102,22,188,67,143,130,218,67,108,66,160,151,67,143,130,218,67,108,143,130,218,67,66,160,151,67,108,143,130,218,67,102,22,188,67,99,101,
	0,0 ];
	
	
	const var draggerPath = Content.createPath();
	
	
	draggerPath.loadFromData(draggerData);
	
	ZoomPanel.setPaintRoutine(function(g)
	{
		g.setColour(Colours.withAlpha(Colours.white, (this.data.hover && this.data.allowDrag) ? 0.8 : 0.2));
		g.fillPath(draggerPath, [8, 4, 14, 14]);
	});
	
	inline function allowZoom(panel, on)
	{
		panel.data.allowDrag = on;
		panel.setMouseCursor(on ?"BottomRightCornerResizeCursor" : "NormalCursor", Colours.white, [0, 0]);
		panel.repaint();
	}
	
	allowZoom(ZoomPanel, true);
	
	ZoomPanel.setMouseCallback(function(event)
	{
		this.data.hover = event.hover;
		
		if(event.clicked)
		{
			this.data.zoomStart = Settings.getZoomLevel();
		}
		if(event.mouseUp)
		{
			return;
		}
	
		if(event.drag)
		{
			if(!this.data.allowDrag)
				return;
	
			var diagonal = Math.sqrt(INTERFACE_WIDTH*INTERFACE_WIDTH + INTERFACE_HEIGHT*INTERFACE_HEIGHT);
			var currentZoom = Settings.getZoomLevel();
			var dragPixel = 0;
			
			if(event.dragX > event.dragY)
				dragPixel = (event.dragX * currentZoom) / INTERFACE_WIDTH;
			else
				dragPixel = (event.dragY * currentZoom) / INTERFACE_HEIGHT;
			
			
			var maxScaleFactor = Content.getScreenBounds(false)[3] / INTERFACE_HEIGHT;
			var diagonalDrag = this.data.zoomStart + dragPixel;
			
			diagonalDrag += (ZOOM_STEP / 2);
			
			diagonalDrag = Math.min(diagonalDrag, maxScaleFactor);
			
			diagonalDrag -= Math.fmod(diagonalDrag, ZOOM_STEP);
			diagonalDrag = Math.range(diagonalDrag, MIN_ZOOM, MAX_ZOOM);
			
			var zoomToUse = diagonalDrag;
	
			if(currentZoom != zoomToUse)
			{
				Settings.setZoomLevel(zoomToUse);
			}
		}
		
		this.repaint();
	});
}function onNoteOn()
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
 