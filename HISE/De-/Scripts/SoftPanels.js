namespace SoftPanels {
	// SoftPanel
	const var pnlDeBoxer = Content.getComponent("pnlDeBoxer");
	const var pnlDeMudder = Content.getComponent("pnlDeMudder");
	const var pnlDeEsser = Content.getComponent("pnlDeEsser");
	
	pnlDeBoxer.setPaintRoutine(drawSubPanel);
	inline function drawSubPanel(g)
	{
		local a = this.getLocalBounds(5);
		
		g.drawDropShadow(a, Colours.withAlpha(Colours.black, 0.6), 10);
		
		a = this.getLocalBounds(5);
		
		g.setColour(this.get("bgColour"));
		g.fillRoundedRectangle(a, this.get("borderRadius"));
	}
	
	pnlDeMudder.setPaintRoutine(drawSubPanel);
	inline function drawSubPanel(g)
	{
		local a = this.getLocalBounds(5);
		
		g.drawDropShadow(a, Colours.withAlpha(Colours.black, 0.6), 10);
		
		a = this.getLocalBounds(3);
		
		g.setColour(this.get("bgColour"));
		g.fillRoundedRectangle(a, this.get("borderRadius"));
	}
	
	pnlDeEsser.setPaintRoutine(drawSubPanel);
	inline function drawSubPanel(g)
	{
		local a = this.getLocalBounds(5);
		
		g.drawDropShadow(a, Colours.withAlpha(Colours.black, 0.6), 10);
		
		a = this.getLocalBounds(5);
		
		g.setColour(this.get("bgColour"));
		g.fillRoundedRectangle(a, this.get("borderRadius"));
	}

}