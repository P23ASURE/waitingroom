namespace project
{

struct script_fx1_networkdata: public scriptnode::dll::InterpretedNetworkData
{
	String getId() const override
	{
		return "script_fx1";
	}
	bool isModNode() const override
	{
		return false;
	}
	String getNetworkData() const override
	{
		return "1720.nT6K8CFEpTWM.XFsidBrTVM.udCylReTw9wj6bkowg7sbwx2BEMqt.Nkrl09lJVNWF0IYZmk.bI.XB.WliSIFoe3sxgWXFkra8+k0ZL4tYJzOW8CRS2r1.8Sx5ABy2DIVtptvvvzjQszg4adyyk216GXbt+QfJo4bAnTQFifRjuWMi3DT+62qpqZLJ24IR4.HibOHX8qTDQrs1sMoerstw4M+.YraW0njNu2pT3x3ykyPJiSTdEYDmsf5mi3jzGf1eV8FneQFkvBIxnHcdz9yHf96x.B9aY8WFM7HQlLe2NCGGDdCx3F+dd4Mwan2jWIOuPNuhu+Qw8C9c7KQpSIFBa614rmmIkFMqLMsJpIUkGfFU0zJyRiFJMTJ0Z5xSPFG8h7DmXyIkl0jZpvHVOe+1C0zAO.J.HCM85Ah6pWdGBgWYRpxI5XKmIxXrBmRHNK.wY6d6w37F49Coqe5111QdhQc8wVL7.9TLIjdNrEWKE0cUBR+8yKK6Rqzes5Q11Qhv1KHSefbf3K3SO7JzXrzF9CovG.zTekLyvgqQPypvxvrxttrnzznTKRJnPd8GdmpGr92W6VppfHR2.cqdjugbLwnns5dWmavv5G.TugbYNd1ObOdCu.t+5QEOgaQ+16mceC43WvlyOZ7IRjJP2vk.Ak+79sSfTpQ0foYoMMM8QDyFOWPxxw8IUIf.FatnZXYyKMroJLG9zoxxInKjsy.yq49iGCAnTXJPpYRondvISXhkClWUVWZUUaOn8dsbLPloQggkQm1gYsyv96njVBJyK5eqeQvTVTHyKR1667PBVxbeLt1s4ETIyW3Kp54Djwcycfutaio4f1q7OVjkXTmAAesiwh6lKT5jNsrnT.nzY.ek93TnWYZxrpnEHvnFcuYFYDH.fDB.D.Ah..FkTJYL7.RhHEICDDHDBLBICS.PAHH.SPfHBhFCPyYDC.URCjewtwv+ipjHdZhPbwUgAZTPHmLZ1jzM9L8pBNVrch5QSlhs9nTBiZGhuMcKZki.Oom+ImekotJg.vnQQv1OCCY0TRm3qSsQExiOf3ibzKLMoUHzHyNWHVYlCnPzkK96z1t48phwtHFt.UWqtE4ywAJlEXes.oH7Amn6FvHXqEf9ZJfVicjF6uTnT1I19DPlC.TdJ9KsTZnLl5yNF7PKmdbE8zWbE9EuYhCOs134MAcXvyWAQwFkv9zI51yNBhihqUs1hQ48TM5xsac5wloaXFoesJPVJBckdzRinu1DwoADIb9LINZNQC7cZzwjQEAOa8Tte7sxysp7ANE8pnWya1kexQVWrMyEvTrYir110BQg1mGfsA9eDKkB8am+AT47JWfBx9kxD7EfoBtKICTK+0IqH1TLf.h2gxY5Mn.zTd.zGZHk4gB6vTmEjj7CkaGhcKQTjSl.rY65JiVh18aG38.eiApWuHThBoVNW5FDfbz.rdwCP.4dqN1mdJY9wgLiqHPvIECRHesxzAXyZXJ0IxI4y2SDoMxOlrOtpco5eRjF0ocvrGBhO2nzkYo54k93IKDAj13iPI8scYigm067ST6qAA5B48EvjVFXgIQSv33VdEjruuvlhjU6FwJo2nKXLOrpxAFuepii4xbQyvgGXbvEBkCL2Pm.m4exL0Cg3MXGAHPw1lIDjrNMj7G9BW5QuqY15Sra8TdpOrot.FOrgaNSvUtwlTSrTh+aTrJZipnbx4xxcOP15H5k+Q63V3H+4NECXU+RY3DRuXVt8Wk9Uaxy9NxY+.YzFrtqUYgQY69VwMURq9sgzddm7C.pAWzOiDA13z5XJktN0f.Ugg43j3OMGU3+p4XtArw0PGArU.f7T+JRpiw+6pN2zoikDFNeuYUk8USW0lPZoZki4gCvWTYVxkNWB.MceSm2hBe7yOAXTxBaEXA9HdpgAekRpOsm9sn0Qq9g1F38GxAWSa3WW314Gzq3tglaSbqiNrkTYO3LXIXXCjCeCC2Mbj0JWXZytQVfXLTF9VkuGXCVtUCkpethwS01+MJaj7QSO1SvSSDehjG.oAb+rlj5SCzR3ROGU8KHCM9+eHIaeM7aBcEBF23Avypz0PDIW3Gu4YwSFfYawQgsfGWmXpy2UPExmLggY7s.67Yu4Tly5JCkDPeAnCVdYuKpSkwTXTbvIB8hHuKyZ2P2IDAhvFoPn4gjUoWYnXCPBgBlZ.tjdxk7rGwTKTy7IXOy.KaEO8vsk+LAzbARblv1375rEBoMzD8yf5DVWnPRAIRvo0Ab10tHnYKk5C6MUpkNk.ua9Vz6lwE.wDQwMjcZJpZjo+5.";
	}
};
}
