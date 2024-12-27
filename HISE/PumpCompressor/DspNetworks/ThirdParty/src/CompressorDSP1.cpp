/* ------------------------------------------------------------
name: "CompressorDSP1"
Code generated with Faust 2.75.7 (https://faust.grame.fr)
Compilation options: -lang cpp -rui -nvi -ct 1 -cn _CompressorDSP1 -scn ::faust::dsp -es 1 -mcd 16 -mdd 1024 -mdy 33 -uim -single -ftz 0
------------------------------------------------------------ */

#ifndef  ___CompressorDSP1_H__
#define  ___CompressorDSP1_H__

#ifndef FAUSTFLOAT
#define FAUSTFLOAT float
#endif 

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <math.h>

#ifndef FAUSTCLASS 
#define FAUSTCLASS _CompressorDSP1
#endif

#ifdef __APPLE__ 
#define exp10f __exp10f
#define exp10 __exp10
#endif

#if defined(_WIN32)
#define RESTRICT __restrict
#else
#define RESTRICT __restrict__
#endif

static float _CompressorDSP1_faustpower2_f(float value) {
	return value * value;
}

struct _CompressorDSP1 final : public ::faust::dsp {
	
	FAUSTFLOAT fEntry0;
	FAUSTFLOAT fEntry1;
	FAUSTFLOAT fHslider0;
	FAUSTFLOAT fHslider1;
	int fSampleRate;
	float fConst0;
	FAUSTFLOAT fHslider2;
	FAUSTFLOAT fHslider3;
	float fRec1[2];
	float fRec0[2];
	FAUSTFLOAT fEntry2;
	FAUSTFLOAT fVbargraph0;
	FAUSTFLOAT fHslider4;
	FAUSTFLOAT fHslider5;
	float fRec3[2];
	float fRec2[2];
	FAUSTFLOAT fVbargraph1;
	
	_CompressorDSP1() {
	}
	
	void metadata(Meta* m) { 
		m->declare("basics.lib/name", "Faust Basic Element Library");
		m->declare("basics.lib/tabulateNd", "Copyright (C) 2023 Bart Brouns <bart@magnetophon.nl>");
		m->declare("basics.lib/version", "1.19.1");
		m->declare("compile_options", "-lang cpp -rui -nvi -ct 1 -cn _CompressorDSP1 -scn ::faust::dsp -es 1 -mcd 16 -mdd 1024 -mdy 33 -uim -single -ftz 0");
		m->declare("filename", "CompressorDSP1.dsp");
		m->declare("maths.lib/author", "GRAME");
		m->declare("maths.lib/copyright", "GRAME");
		m->declare("maths.lib/license", "LGPL with exception");
		m->declare("maths.lib/name", "Faust Math Library");
		m->declare("maths.lib/version", "2.8.0");
		m->declare("name", "CompressorDSP1");
		m->declare("platform.lib/name", "Generic Platform Library");
		m->declare("platform.lib/version", "1.3.0");
		m->declare("signals.lib/name", "Faust Signal Routing Library");
		m->declare("signals.lib/version", "1.6.0");
	}

	static constexpr int getStaticNumInputs() {
		return 2;
	}
	static constexpr int getStaticNumOutputs() {
		return 2;
	}
	int getNumInputs() {
		return 2;
	}
	int getNumOutputs() {
		return 2;
	}
	
	static void classInit(int sample_rate) {
	}
	
	void instanceConstants(int sample_rate) {
		fSampleRate = sample_rate;
		fConst0 = 1.0f / std::min<float>(1.92e+05f, std::max<float>(1.0f, float(fSampleRate)));
	}
	
	void instanceResetUserInterface() {
		fEntry0 = FAUSTFLOAT(3.0f);
		fEntry1 = FAUSTFLOAT(-2e+01f);
		fHslider0 = FAUSTFLOAT(0.0f);
		fHslider1 = FAUSTFLOAT(5e+02f);
		fHslider2 = FAUSTFLOAT(2.0f);
		fHslider3 = FAUSTFLOAT(0.0f);
		fEntry2 = FAUSTFLOAT(2.0f);
		fHslider4 = FAUSTFLOAT(1e+02f);
		fHslider5 = FAUSTFLOAT(0.0f);
	}
	
	void instanceClear() {
		for (int l0 = 0; l0 < 2; l0 = l0 + 1) {
			fRec1[l0] = 0.0f;
		}
		for (int l1 = 0; l1 < 2; l1 = l1 + 1) {
			fRec0[l1] = 0.0f;
		}
		for (int l2 = 0; l2 < 2; l2 = l2 + 1) {
			fRec3[l2] = 0.0f;
		}
		for (int l3 = 0; l3 < 2; l3 = l3 + 1) {
			fRec2[l3] = 0.0f;
		}
	}
	
	void init(int sample_rate) {
		classInit(sample_rate);
		instanceInit(sample_rate);
	}
	
	void instanceInit(int sample_rate) {
		instanceConstants(sample_rate);
		instanceResetUserInterface();
		instanceClear();
	}
	
	_CompressorDSP1* clone() {
		return new _CompressorDSP1();
	}
	
	int getSampleRate() {
		return fSampleRate;
	}
	
	void buildUserInterface(UI* ui_interface) {
		ui_interface->openVerticalBox("CompressorDSP1");
		ui_interface->openHorizontalBox("1-compression");
		ui_interface->addNumEntry("knee", &fEntry0, FAUSTFLOAT(3.0f), FAUSTFLOAT(0.0f), FAUSTFLOAT(2e+01f), FAUSTFLOAT(0.1f));
		ui_interface->addNumEntry("ratio", &fEntry2, FAUSTFLOAT(2.0f), FAUSTFLOAT(1.0f), FAUSTFLOAT(2e+01f), FAUSTFLOAT(0.1f));
		ui_interface->addNumEntry("threshold", &fEntry1, FAUSTFLOAT(-2e+01f), FAUSTFLOAT(-96.0f), FAUSTFLOAT(1e+01f), FAUSTFLOAT(0.1f));
		ui_interface->closeBox();
		ui_interface->openVerticalBox("2-envelop");
		ui_interface->declare(&fHslider3, "unit", "ms");
		ui_interface->addHorizontalSlider("Add/Remove Attack", &fHslider3, FAUSTFLOAT(0.0f), FAUSTFLOAT(-1e+03f), FAUSTFLOAT(1e+03f), FAUSTFLOAT(0.1f));
		ui_interface->declare(&fHslider0, "unit", "ms");
		ui_interface->addHorizontalSlider("Add/Remove Release", &fHslider0, FAUSTFLOAT(0.0f), FAUSTFLOAT(-1e+03f), FAUSTFLOAT(1e+03f), FAUSTFLOAT(0.1f));
		ui_interface->declare(&fHslider2, "unit", "ms");
		ui_interface->addHorizontalSlider("Attack", &fHslider2, FAUSTFLOAT(2.0f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1e+03f), FAUSTFLOAT(0.1f));
		ui_interface->declare(&fHslider1, "unit", "ms");
		ui_interface->addHorizontalSlider("Release", &fHslider1, FAUSTFLOAT(5e+02f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1e+04f), FAUSTFLOAT(1.0f));
		ui_interface->closeBox();
		ui_interface->openVerticalBox("3-gain");
		ui_interface->addHorizontalSlider("makeup gain", &fHslider5, FAUSTFLOAT(0.0f), FAUSTFLOAT(-96.0f), FAUSTFLOAT(96.0f), FAUSTFLOAT(0.1f));
		ui_interface->closeBox();
		ui_interface->openVerticalBox("4-channel linking");
		ui_interface->addHorizontalSlider("channel link", &fHslider4, FAUSTFLOAT(1e+02f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1e+02f), FAUSTFLOAT(1.0f));
		ui_interface->closeBox();
		ui_interface->openVerticalBox("5-metering");
		ui_interface->declare(&fVbargraph0, "unit", "dB");
		ui_interface->addVerticalBargraph("Left GR", &fVbargraph0, FAUSTFLOAT(-6e+01f), FAUSTFLOAT(0.0f));
		ui_interface->declare(&fVbargraph1, "unit", "dB");
		ui_interface->addVerticalBargraph("Right GR", &fVbargraph1, FAUSTFLOAT(-6e+01f), FAUSTFLOAT(0.0f));
		ui_interface->closeBox();
		ui_interface->closeBox();
	}
	
	void compute(int count, FAUSTFLOAT** RESTRICT inputs, FAUSTFLOAT** RESTRICT outputs) {
		FAUSTFLOAT* input0 = inputs[0];
		FAUSTFLOAT* input1 = inputs[1];
		FAUSTFLOAT* output0 = outputs[0];
		FAUSTFLOAT* output1 = outputs[1];
		float fSlow0 = std::max<float>(0.0f, std::min<float>(2e+01f, float(fEntry0)));
		float fSlow1 = 0.5f * fSlow0;
		float fSlow2 = std::max<float>(-96.0f, std::min<float>(1e+01f, float(fEntry1)));
		float fSlow3 = 0.001f * std::max<float>(0.1f, std::max<float>(0.0f, std::min<float>(1e+04f, float(fHslider1))) + std::max<float>(-1e+03f, std::min<float>(1e+03f, float(fHslider0))));
		int iSlow4 = std::fabs(fSlow3) < 1.1920929e-07f;
		float fSlow5 = ((iSlow4) ? 0.0f : std::exp(-(fConst0 / ((iSlow4) ? 1.0f : fSlow3))));
		float fSlow6 = 1.0f - fSlow5;
		float fSlow7 = 0.001f * std::max<float>(0.1f, std::max<float>(-1e+03f, std::min<float>(1e+03f, float(fHslider3))) + std::max<float>(0.0f, std::min<float>(1e+03f, float(fHslider2))));
		int iSlow8 = std::fabs(fSlow7) < 1.1920929e-07f;
		float fSlow9 = ((iSlow8) ? 0.0f : std::exp(-(fConst0 / ((iSlow8) ? 1.0f : fSlow7))));
		float fSlow10 = 1.0f - fSlow9;
		float fSlow11 = -0.5f * fSlow0;
		float fSlow12 = 0.5f / fSlow0;
		float fSlow13 = 1.0f - 1.0f / std::max<float>(std::max<float>(1.0f, std::min<float>(2e+01f, float(fEntry2))), 1.000001f);
		float fSlow14 = 0.05f * fSlow13;
		float fSlow15 = 0.01f * std::max<float>(0.0f, std::min<float>(1e+02f, float(fHslider4)));
		float fSlow16 = std::pow(1e+01f, 0.05f * std::max<float>(-96.0f, std::min<float>(96.0f, float(fHslider5))));
		float fSlow17 = fSlow16 * (1.0f - fSlow15);
		for (int i0 = 0; i0 < count; i0 = i0 + 1) {
			float fTemp0 = float(input0[i0]);
			fRec1[0] = std::fabs(fTemp0) * fSlow10 + fRec1[1] * fSlow9;
			fRec0[0] = fRec0[1] * fSlow5 + fRec1[0] * fSlow6;
			float fTemp1 = 2e+01f * std::log10(std::max<float>(1.1754944e-38f, fRec0[0])) - fSlow2;
			float fTemp2 = fTemp1 * float(fTemp1 > fSlow1) + fSlow12 * _CompressorDSP1_faustpower2_f(fSlow1 + fTemp1) * float((fTemp1 > fSlow11) & (fTemp1 <= fSlow1));
			fVbargraph0 = FAUSTFLOAT(-(fSlow13 * fTemp2));
			float fTemp3 = std::pow(1e+01f, -(fSlow14 * fTemp2));
			float fTemp4 = float(input1[i0]);
			fRec3[0] = std::fabs(fTemp4) * fSlow10 + fSlow9 * fRec3[1];
			fRec2[0] = fRec3[0] * fSlow6 + fSlow5 * fRec2[1];
			float fTemp5 = 2e+01f * std::log10(std::max<float>(1.1754944e-38f, fRec2[0])) - fSlow2;
			float fTemp6 = fSlow12 * float((fTemp5 > fSlow11) & (fTemp5 <= fSlow1)) * _CompressorDSP1_faustpower2_f(fSlow1 + fTemp5) + fTemp5 * float(fTemp5 > fSlow1);
			float fTemp7 = std::pow(1e+01f, -(fSlow14 * fTemp6));
			float fTemp8 = fSlow15 * std::min<float>(fSlow16 * fTemp3, fSlow16 * fTemp7);
			output0[i0] = FAUSTFLOAT(fTemp0 * (fTemp8 + fSlow17 * fTemp3));
			fVbargraph1 = FAUSTFLOAT(-(fSlow13 * fTemp6));
			output1[i0] = FAUSTFLOAT(fTemp4 * (fTemp8 + fSlow17 * fTemp7));
			fRec1[1] = fRec1[0];
			fRec0[1] = fRec0[0];
			fRec3[1] = fRec3[0];
			fRec2[1] = fRec2[0];
		}
	}

};

#ifdef FAUST_UIMACROS
	
	#define FAUST_FILE_NAME "CompressorDSP1.dsp"
	#define FAUST_CLASS_NAME "_CompressorDSP1"
	#define FAUST_COMPILATION_OPIONS "-lang cpp -rui -nvi -ct 1 -cn _CompressorDSP1 -scn ::faust::dsp -es 1 -mcd 16 -mdd 1024 -mdy 33 -uim -single -ftz 0"
	#define FAUST_INPUTS 2
	#define FAUST_OUTPUTS 2
	#define FAUST_ACTIVES 9
	#define FAUST_PASSIVES 2

	FAUST_ADDNUMENTRY("1-compression/knee", fEntry0, 3.0f, 0.0f, 2e+01f, 0.1f);
	FAUST_ADDNUMENTRY("1-compression/ratio", fEntry2, 2.0f, 1.0f, 2e+01f, 0.1f);
	FAUST_ADDNUMENTRY("1-compression/threshold", fEntry1, -2e+01f, -96.0f, 1e+01f, 0.1f);
	FAUST_ADDHORIZONTALSLIDER("2-envelop/Add/Remove Attack", fHslider3, 0.0f, -1e+03f, 1e+03f, 0.1f);
	FAUST_ADDHORIZONTALSLIDER("2-envelop/Add/Remove Release", fHslider0, 0.0f, -1e+03f, 1e+03f, 0.1f);
	FAUST_ADDHORIZONTALSLIDER("2-envelop/Attack", fHslider2, 2.0f, 0.0f, 1e+03f, 0.1f);
	FAUST_ADDHORIZONTALSLIDER("2-envelop/Release", fHslider1, 5e+02f, 0.0f, 1e+04f, 1.0f);
	FAUST_ADDHORIZONTALSLIDER("3-gain/makeup gain", fHslider5, 0.0f, -96.0f, 96.0f, 0.1f);
	FAUST_ADDHORIZONTALSLIDER("4-channel linking/channel link", fHslider4, 1e+02f, 0.0f, 1e+02f, 1.0f);
	FAUST_ADDVERTICALBARGRAPH("5-metering/Left GR", fVbargraph0, -6e+01f, 0.0f);
	FAUST_ADDVERTICALBARGRAPH("5-metering/Right GR", fVbargraph1, -6e+01f, 0.0f);

	#define FAUST_LIST_ACTIVES(p) \
		p(NUMENTRY, knee, "1-compression/knee", fEntry0, 3.0f, 0.0f, 2e+01f, 0.1f) \
		p(NUMENTRY, ratio, "1-compression/ratio", fEntry2, 2.0f, 1.0f, 2e+01f, 0.1f) \
		p(NUMENTRY, threshold, "1-compression/threshold", fEntry1, -2e+01f, -96.0f, 1e+01f, 0.1f) \
		p(HORIZONTALSLIDER, Add/Remove_Attack, "2-envelop/Add/Remove Attack", fHslider3, 0.0f, -1e+03f, 1e+03f, 0.1f) \
		p(HORIZONTALSLIDER, Add/Remove_Release, "2-envelop/Add/Remove Release", fHslider0, 0.0f, -1e+03f, 1e+03f, 0.1f) \
		p(HORIZONTALSLIDER, Attack, "2-envelop/Attack", fHslider2, 2.0f, 0.0f, 1e+03f, 0.1f) \
		p(HORIZONTALSLIDER, Release, "2-envelop/Release", fHslider1, 5e+02f, 0.0f, 1e+04f, 1.0f) \
		p(HORIZONTALSLIDER, makeup_gain, "3-gain/makeup gain", fHslider5, 0.0f, -96.0f, 96.0f, 0.1f) \
		p(HORIZONTALSLIDER, channel_link, "4-channel linking/channel link", fHslider4, 1e+02f, 0.0f, 1e+02f, 1.0f) \

	#define FAUST_LIST_PASSIVES(p) \
		p(VERTICALBARGRAPH, Left_GR, "5-metering/Left GR", fVbargraph0, 0.0, -6e+01f, 0.0f, 0.0) \
		p(VERTICALBARGRAPH, Right_GR, "5-metering/Right GR", fVbargraph1, 0.0, -6e+01f, 0.0f, 0.0) \

#endif

#endif
