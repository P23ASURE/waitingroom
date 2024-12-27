/* ------------------------------------------------------------
name: "StereoWidenerDSP"
Code generated with Faust 2.75.7 (https://faust.grame.fr)
Compilation options: -lang cpp -rui -nvi -ct 1 -cn _StereoWidenerDSP -scn ::faust::dsp -es 1 -mcd 16 -mdd 1024 -mdy 33 -uim -single -ftz 0
------------------------------------------------------------ */

#ifndef  ___StereoWidenerDSP_H__
#define  ___StereoWidenerDSP_H__

#ifndef FAUSTFLOAT
#define FAUSTFLOAT float
#endif 

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <math.h>

#ifndef FAUSTCLASS 
#define FAUSTCLASS _StereoWidenerDSP
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


struct _StereoWidenerDSP final : public ::faust::dsp {
	
	int IOTA0;
	float fVec0[2048];
	int fSampleRate;
	int iConst0;
	FAUSTFLOAT fVslider0;
	
	_StereoWidenerDSP() {
	}
	
	void metadata(Meta* m) { 
		m->declare("compile_options", "-lang cpp -rui -nvi -ct 1 -cn _StereoWidenerDSP -scn ::faust::dsp -es 1 -mcd 16 -mdd 1024 -mdy 33 -uim -single -ftz 0");
		m->declare("filename", "StereoWidenerDSP.dsp");
		m->declare("maths.lib/author", "GRAME");
		m->declare("maths.lib/copyright", "GRAME");
		m->declare("maths.lib/license", "LGPL with exception");
		m->declare("maths.lib/name", "Faust Math Library");
		m->declare("maths.lib/version", "2.8.0");
		m->declare("name", "StereoWidenerDSP");
		m->declare("platform.lib/name", "Generic Platform Library");
		m->declare("platform.lib/version", "1.3.0");
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
		iConst0 = int(0.01f * std::min<float>(1.92e+05f, std::max<float>(1.0f, float(fSampleRate))));
	}
	
	void instanceResetUserInterface() {
		fVslider0 = FAUSTFLOAT(1.0f);
	}
	
	void instanceClear() {
		IOTA0 = 0;
		for (int l0 = 0; l0 < 2048; l0 = l0 + 1) {
			fVec0[l0] = 0.0f;
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
	
	_StereoWidenerDSP* clone() {
		return new _StereoWidenerDSP();
	}
	
	int getSampleRate() {
		return fSampleRate;
	}
	
	void buildUserInterface(UI* ui_interface) {
		ui_interface->openVerticalBox("StereoWidenerDSP");
		ui_interface->addVerticalSlider("width", &fVslider0, FAUSTFLOAT(1.0f), FAUSTFLOAT(0.0f), FAUSTFLOAT(2.0f), FAUSTFLOAT(0.01f));
		ui_interface->closeBox();
	}
	
	void compute(int count, FAUSTFLOAT** RESTRICT inputs, FAUSTFLOAT** RESTRICT outputs) {
		FAUSTFLOAT* input0 = inputs[0];
		FAUSTFLOAT* input1 = inputs[1];
		FAUSTFLOAT* output0 = outputs[0];
		FAUSTFLOAT* output1 = outputs[1];
		float fSlow0 = std::max<float>(0.0f, std::min<float>(2.0f, float(fVslider0))) + -1.0f;
		float fSlow1 = std::max<float>(0.0f, fSlow0);
		for (int i0 = 0; i0 < count; i0 = i0 + 1) {
			float fTemp0 = float(input1[i0]);
			float fTemp1 = float(input0[i0]);
			fVec0[IOTA0 & 2047] = fTemp1;
			float fTemp2 = 0.5f * (fSlow0 * (fTemp1 - fTemp0) + fSlow1 * (fVec0[(IOTA0 - iConst0) & 2047] - fTemp0));
			output0[i0] = FAUSTFLOAT(fTemp1 + fTemp2);
			output1[i0] = FAUSTFLOAT(fTemp0 - fTemp2);
			IOTA0 = IOTA0 + 1;
		}
	}

};

#ifdef FAUST_UIMACROS
	
	#define FAUST_FILE_NAME "StereoWidenerDSP.dsp"
	#define FAUST_CLASS_NAME "_StereoWidenerDSP"
	#define FAUST_COMPILATION_OPIONS "-lang cpp -rui -nvi -ct 1 -cn _StereoWidenerDSP -scn ::faust::dsp -es 1 -mcd 16 -mdd 1024 -mdy 33 -uim -single -ftz 0"
	#define FAUST_INPUTS 2
	#define FAUST_OUTPUTS 2
	#define FAUST_ACTIVES 1
	#define FAUST_PASSIVES 0

	FAUST_ADDVERTICALSLIDER("width", fVslider0, 1.0f, 0.0f, 2.0f, 0.01f);

	#define FAUST_LIST_ACTIVES(p) \
		p(VERTICALSLIDER, width, "width", fVslider0, 1.0f, 0.0f, 2.0f, 0.01f) \

	#define FAUST_LIST_PASSIVES(p) \

#endif

#endif
