Content.makeFrontInterface(590, 640);
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

// SCALE GUI
namespace ZoomHandler
{
	const var MIN_ZOOM = 0.85;
	const var MAX_ZOOM = 2.0;
	const var ZOOM_STEP = 0.1;
	const var INTERFACE_WIDTH = 590;
	const var INTERFACE_HEIGHT = 640;

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
}
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
 