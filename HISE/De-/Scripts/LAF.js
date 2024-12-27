namespace LAF {
	// ====== KNOB LAF ===
	// Horizontal
	const knblaf = Content.createLocalLookAndFeel();
	knblaf.registerFunction("drawLinearSlider", function(g, obj)
	{
		var a = obj.area;
		var handle = a[2]/6;
		var n = (a[2] - handle) / a[2];
		var v = obj.valueNormalized * n;
		
		//	bg
		g.setColour(obj.bgColour); 
		g.fillRoundedRectangle(a, a[3]*0.5);
		
		//	
		g.setColour(Colours.lightgrey);
		g.fillRoundedRectangle([0, 0, a[2]*v + handle, a[3]], a[3]*0.5);
		
		//	handle
		g.setColour(Colours.whitesmoke);
		g.fillRoundedRectangle([a[2]*v, 0, handle, a[3]], a[3]*0.5);
		
		//text    
		if ((obj.value) > 300)
		 {
			g.setColour(0xFF424242);
		 }
		 else
		 {
		 	g.setColour(0xFFFFFFFF);
		 };
		 g.setFont("UnisansALLCAPS", 10.0);
		 g.drawAlignedText(Math.round(obj.value) + " hz", [0,(a[3]/2)-9,a[2],16], "centred");
			
	});
	
	const knblaf2 = Content.createLocalLookAndFeel();
	knblaf2.registerFunction("drawLinearSlider", function(g, obj)
	{
		var a = obj.area;
		var handle = a[2]/6;
		var n = (a[2] - handle) / a[2];
		var v = obj.valueNormalized * n;
		
		//	bg
		g.setColour(obj.bgColour); 
		g.fillRoundedRectangle(a, a[3]*0.5);
		
		//	
		g.setColour(Colours.lightgrey);
		g.fillRoundedRectangle([0, 0, a[2]*v + handle, a[3]], a[3]*0.5);
		
		//	handle
		g.setColour(Colours.whitesmoke);
		g.fillRoundedRectangle([a[2]*v, 0, handle, a[3]], a[3]*0.5);
		
		//text    
		if ((obj.value) > 200)
		 {
			g.setColour(0xFF424242);
		 }
		 else
		 {
		 	g.setColour(0xFFFFFFFF);
		 };
		 g.setFont("UnisansALLCAPS", 10.0);
		 g.drawAlignedText(Math.round(obj.value) + " Hz", [0,(a[3]/2)-9,a[2],16], "centred");
	
	});
	
	const knblaf3 = Content.createLocalLookAndFeel();
	knblaf3.registerFunction("drawLinearSlider", function(g, obj)
	{
		var a = obj.area;
		var handle = a[2]/6;
		var n = (a[2] - handle) / a[2];
		var v = obj.valueNormalized * n;
		
		//	bg
		g.setColour(obj.bgColour); 
		g.fillRoundedRectangle(a, a[3]*0.5);
		
		//	
		g.setColour(Colours.lightgrey);
		g.fillRoundedRectangle([0, 0, a[2]*v + handle, a[3]], a[3]*0.5);
		
		//	handle
		g.setColour(Colours.whitesmoke);
		g.fillRoundedRectangle([a[2]*v, 0, handle, a[3]], a[3]*0.5);
		
		//text    
		if ((obj.value) > 5600)
		 {
			g.setColour(0xFF424242);
		 }
		 else
		 {
		 	g.setColour(0xFFFFFFFF);
		 };
		 g.setFont("UnisansALLCAPS", 10.0);
		 g.drawAlignedText(Math.round(obj.value) + " Hz", [0,(a[3]/2)-9,a[2],16], "centred");
	
	});
	
	knbDeEssFrequency.setLocalLookAndFeel(knblaf3);
	knbFrequencyDeBox.setLocalLookAndFeel(knblaf);
	knbDeMudFrequency.setLocalLookAndFeel(knblaf2);
	
	// Vertical
	
	const knblafVertical = Content.createLocalLookAndFeel();
	knblafVertical.registerFunction("drawLinearSlider", function(g, obj)
	{
	    var a = obj.area;
	    var handle = a[3]/6;
	    var n = (a[3] - handle) / a[3];
	    
	    var v = Math.max(0, Math.min(1, (1.0 - obj.valueNormalized))) * n;
	    
	    
	    // bg
	    g.setColour(obj.bgColour);
	    g.fillRoundedRectangle(a, a[2]*0.5);
	    
	    // filled area
	    g.setColour(Colours.lightgrey);
	    g.fillRoundedRectangle([0, 0, a[2], a[3]*v + handle], a[2]*0.5);
	 
	    // handle
	    g.setColour(Colours.whitesmoke);
	    g.fillRoundedRectangle([0, a[3]*v, a[2], handle], a[2]*0.2);
	    
	    //text    
	    if ((obj.value*-1) > 13)
	     {
	    	g.setColour(0xFF424242);
	     }
	     else
	     {
	     	g.setColour(0xFFFFFFFF);
	     };
	     g.setFont("UnisansALLCAPS", 10.0);
	     g.drawAlignedText(Math.round(obj.value) + " dB", [0,(a[3]/2)-9,a[2],12], "centred");
	    
	});
	
	const knblafVertical2 = Content.createLocalLookAndFeel();
	knblafVertical2.registerFunction("drawLinearSlider", function(g, obj)
	{
	    var a = obj.area;
	    var handle = a[3]/6;
	    var n = (a[3] - handle) / a[3];
	    
	    var v = Math.max(0, Math.min(1, (1.0 - obj.valueNormalized))) * n;
	    
	    // bg
	    g.setColour(obj.bgColour);
	    g.fillRoundedRectangle(a, a[2]*0.5);
	    
	    // filled area
	    g.setColour(Colours.lightgrey);
	    g.fillRoundedRectangle([0, 0, a[2], a[3]*v + handle], a[2]*0.5);
	 
	    // handle
	    g.setColour(Colours.whitesmoke);
	    g.fillRoundedRectangle([0, a[3]*v, a[2], handle], a[2]*0.2);
	    
	    //text    
	    if ((obj.value*-1) > 6)
	     {
	    	g.setColour(0xFF424242);
	     }
	     else
	     {
	     	g.setColour(0xFFFFFFFF);
	     };
	     g.setFont("UnisansALLCAPS", 10.0);
	     g.drawAlignedText(Math.round(obj.value) + " dB", [0,(a[3]/2)-9,a[2],12], "centred");
	    
	});
	knbDeBoxThreshold.setLocalLookAndFeel(knblafVertical);
	knbDeMudThreshold.setLocalLookAndFeel(knblafVertical);
	knbDeEssThreshold.setLocalLookAndFeel(knblafVertical);
	
	knbDeBoxRange.setLocalLookAndFeel(knblafVertical2);
	knbDeMudRange.setLocalLookAndFeel(knblafVertical2);
	knbDeEssRange.setLocalLookAndFeel(knblafVertical2);
	
	// BUTTON LAF
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
	
	btnPeak.setLocalLookAndFeel(LAF_SmallToggleButton);
	btnShelf.setLocalLookAndFeel(LAF_SmallToggleButton);
	
	// KNOB LAF
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
	
		g.setGradientFill([0xFFFFFFFF, 0, 0, 0xFF424242, obj.area[2], 0]);
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
	knbDeBoxQ.setLocalLookAndFeel(locl_laf);
	knbDeEssQ.setLocalLookAndFeel(locl_laf);
	knbDeMudQ.setLocalLookAndFeel(locl_laf);
	
	// ICONS
	const var pnlPresetIcon = Content.getComponent("pnlPresetIcon");
	const var btnPreset = Content.getComponent("btnPreset");
	
	const var svgPresetIcon = Content.createSVG("605.nT6K8CVqDzoD.X52iUB7vwL.dI3llraG5vFNHW3SrdFUd6Fqwb.WIo8+Bmj9y.u7wyGLeA.W.TE.SnjwVngEkkzPJXoO2Pb18gBva8zcJBekEQ69.NDHfGuosoeNiwnljUUVTFgHUF+0tuqqKFKHaaq50OFNHFm+rQPBH5HRhDiPpSDi9qgjfBFDgCMEmVefCTHARCQFvQPDCH3AccYYQ2cwdPSXYfyTXHEMwuWShvt8K977Lw.y5pRAzISKa4CpB1ftqEW+jRIERC6hRk9M+4CBCaokubUaSVc8qRlT57f1pnrtUsi.d3dqcgwR57sh0BsFA.kPac5UOLLt8qSWZ9VF+4sT+h9UJ0qVd4za9E24YboT04rO05UMuCyDZe4yBkpsnLJG8iGc9LPvrvW7fxhjt4qTTdK9jd9ZkyQPnlTgUScw.m2z5W..On3zhXXIKpX7sAzql+hk51kllJz9MMUJaTkUm64WjTJiCcn6RNUuhxMovF1P3k8elyGeworw7oSY0Y9oDiC0qMWNeiOoOKU02og0WJQe6SkCF7EpgSkoPSAHfnBqgM.XDYn7JH7zZkBQUDETEn1++2vpJ+afG7e.gGNvYO+5JlRG4W6okAf4x5k6LqATj.aprQDWw4BOJdcaEnCqmLyUi+CQrnFhRqR.lpEUCiYCHDRDnhzNPlSkgfQ+J3LfKKW+fehQoHHepEDCPIHW90VTzijMqseUMuLbhni0Eh3cpFYB7POrulNrl4yWjQ+76LIYMvluvZ3hhsbnkgYDygFUQm.JFGKDAiDCC5KOnsXYvKraz8.");
	
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
	

	}

