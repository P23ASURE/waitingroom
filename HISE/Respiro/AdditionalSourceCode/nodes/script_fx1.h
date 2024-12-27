#pragma once

// These will improve the readability of the connection definition

#define getT(Idx) template get<Idx>()
#define connectT(Idx, target) template connect<Idx>(target)
#define getParameterT(Idx) template getParameter<Idx>()
#define setParameterT(Idx, value) template setParameter<Idx>(value)
#define setParameterWT(Idx, value) template setWrapParameter<Idx>(value)
using namespace scriptnode;
using namespace snex;
using namespace snex::Types;

namespace script_fx1_impl
{
// ==============================| Node & Parameter type declarations |==============================

template <int NV>
using sb1_t_ = container::chain<parameter::empty, 
                                wrap::fix<2, math::mul<NV>>>;

template <int NV>
using sb1_t = bypass::smoothed<20, sb1_t_<NV>>;
template <int NV>
using switcher_c0 = parameter::bypass<sb1_t<NV>>;

struct matrix_t_matrix: public routing::static_matrix<2, matrix_t_matrix, false>
{
	static constexpr int channels[2] =
	{
		1, 1
	};
};

struct matrix1_t_matrix: public routing::static_matrix<2, matrix1_t_matrix, false>
{
	static constexpr int channels[2] =
	{
		0, 0
	};
};

using split_t = container::split<parameter::empty, 
                                 wrap::fix<2, routing::matrix<matrix_t_matrix>>, 
                                 routing::matrix<matrix1_t_matrix>>;

template <int NV>
using sb2_t_ = container::chain<parameter::empty, 
                                wrap::fix<2, math::mul<NV>>, 
                                split_t>;

template <int NV>
using sb2_t = bypass::smoothed<20, sb2_t_<NV>>;
template <int NV>
using switcher_c1 = parameter::bypass<sb2_t<NV>>;

template <int NV>
using switcher_multimod = parameter::list<switcher_c0<NV>, switcher_c1<NV>>;

template <int NV>
using switcher_t = control::xfader<switcher_multimod<NV>, faders::switcher>;

template <int NV>
using sb_container_t = container::chain<parameter::empty, 
                                        wrap::fix<2, sb1_t<NV>>, 
                                        sb2_t<NV>>;

namespace softbypass_switch3_t_parameters
{
}

template <int NV>
using softbypass_switch3_t = container::chain<parameter::plain<script_fx1_impl::switcher_t<NV>, 0>, 
                                              wrap::fix<2, core::gain<NV>>, 
                                              switcher_t<NV>, 
                                              sb_container_t<NV>>;

template <int NV>
using band1_t = container::chain<parameter::empty, 
                                 wrap::fix<2, jdsp::jlinkwitzriley>, 
                                 jdsp::jlinkwitzriley, 
                                 jdsp::jlinkwitzriley, 
                                 math::mul<NV>, 
                                 softbypass_switch3_t<NV>>;
using goniometer_t = wrap::data<analyse::goniometer, 
                                data::external::displaybuffer<0>>;
using cable_table_t = wrap::data<control::cable_table<parameter::empty>, 
                                 data::external::table<0>>;

template <int NV>
using band2_t = container::chain<parameter::empty, 
                                 wrap::fix<2, jdsp::jlinkwitzriley>, 
                                 jdsp::jlinkwitzriley, 
                                 jdsp::jlinkwitzriley, 
                                 project::StereoWidenerDSP<NV>, 
                                 core::gain<NV>, 
                                 math::mul<NV>, 
                                 goniometer_t, 
                                 cable_table_t>;
using goniometer1_t = wrap::data<analyse::goniometer, 
                                 data::external::displaybuffer<1>>;
using cable_table1_t = wrap::data<control::cable_table<parameter::empty>, 
                                  data::external::table<1>>;

template <int NV>
using band3_t = container::chain<parameter::empty, 
                                 wrap::fix<2, jdsp::jlinkwitzriley>, 
                                 jdsp::jlinkwitzriley, 
                                 jdsp::jlinkwitzriley, 
                                 project::StereoWidenerDSP<NV>, 
                                 core::gain<NV>, 
                                 math::mul<NV>, 
                                 goniometer1_t, 
                                 cable_table1_t>;
using goniometer2_t = wrap::data<analyse::goniometer, 
                                 data::external::displaybuffer<2>>;
using cable_table2_t = wrap::data<control::cable_table<parameter::empty>, 
                                  data::external::table<2>>;

template <int NV>
using band4_t = container::chain<parameter::empty, 
                                 wrap::fix<2, jdsp::jlinkwitzriley>, 
                                 jdsp::jlinkwitzriley, 
                                 jdsp::jlinkwitzriley, 
                                 project::StereoWidenerDSP<NV>, 
                                 core::gain<NV>, 
                                 math::mul<NV>, 
                                 goniometer2_t, 
                                 cable_table2_t>;

namespace freq_split5_t_parameters
{
// Parameter list for script_fx1_impl::freq_split5_t -----------------------------------------------

DECLARE_PARAMETER_RANGE_SKEW(Band1_InputRange, 
                             20., 
                             20000., 
                             0.229905);
DECLARE_PARAMETER_RANGE_SKEW(Band1_0Range, 
                             20., 
                             20000., 
                             0.229905);

using Band1_0 = parameter::from0To1<jdsp::jlinkwitzriley, 
                                    0, 
                                    Band1_0Range>;

using Band1_1 = Band1_0;

using Band1_2 = Band1_0;

using Band1_3 = Band1_0;

using Band1 = parameter::chain<Band1_InputRange, 
                               Band1_0, 
                               Band1_1, 
                               Band1_2, 
                               Band1_3, 
                               parameter::plain<script_fx1_impl::cable_table_t, 0>>;

DECLARE_PARAMETER_RANGE_SKEW(Band2_InputRange, 
                             20., 
                             20000., 
                             0.229905);
using Band2_0 = Band1_0;

using Band2_1 = Band1_0;

using Band2_2 = Band1_0;

using Band2_3 = Band1_0;

using Band2 = parameter::chain<Band2_InputRange, 
                               Band2_0, 
                               Band2_1, 
                               Band2_2, 
                               Band2_3, 
                               parameter::plain<script_fx1_impl::cable_table1_t, 0>>;

DECLARE_PARAMETER_RANGE_SKEW(Band3_InputRange, 
                             20., 
                             20000., 
                             0.229905);
using Band3_0 = Band1_0;

using Band3_1 = Band1_0;

using Band3_2 = Band1_0;

using Band3_3 = Band1_0;

using Band3 = parameter::chain<Band3_InputRange, 
                               Band3_0, 
                               Band3_1, 
                               Band3_2, 
                               Band3_3, 
                               parameter::plain<script_fx1_impl::cable_table2_t, 0>>;

using freq_split5_t_plist = parameter::list<Band1, 
                                            Band2, 
                                            Band3>;
}

template <int NV>
using freq_split5_t = container::split<freq_split5_t_parameters::freq_split5_t_plist, 
                                       wrap::fix<2, band1_t<NV>>, 
                                       band2_t<NV>, 
                                       band3_t<NV>, 
                                       band4_t<NV>>;

namespace script_fx1_t_parameters
{
// Parameter list for script_fx1_impl::script_fx1_t ------------------------------------------------

template <int NV>
using Band1 = parameter::plain<script_fx1_impl::freq_split5_t<NV>, 
                               0>;
template <int NV>
using Band2 = parameter::plain<script_fx1_impl::freq_split5_t<NV>, 
                               1>;
template <int NV>
using Band3 = parameter::plain<script_fx1_impl::freq_split5_t<NV>, 
                               2>;
template <int NV>
using Width1 = parameter::plain<project::StereoWidenerDSP<NV>, 
                                0>;
template <int NV> using Width2 = Width1<NV>;
template <int NV> using Width3 = Width1<NV>;
template <int NV>
using Gain1 = parameter::plain<core::gain<NV>, 0>;
template <int NV> using Gain2 = Gain1<NV>;
template <int NV> using Gain3 = Gain1<NV>;
template <int NV>
using Mono = parameter::plain<script_fx1_impl::softbypass_switch3_t<NV>, 
                              0>;
template <int NV> using Gain0 = Gain1<NV>;
template <int NV>
using script_fx1_t_plist = parameter::list<Band1<NV>, 
                                           Band2<NV>, 
                                           Band3<NV>, 
                                           Width1<NV>, 
                                           Width2<NV>, 
                                           Width3<NV>, 
                                           Gain1<NV>, 
                                           Gain2<NV>, 
                                           Gain3<NV>, 
                                           Mono<NV>, 
                                           Gain0<NV>>;
}

template <int NV>
using script_fx1_t_ = container::chain<script_fx1_t_parameters::script_fx1_t_plist<NV>, 
                                       wrap::fix<2, freq_split5_t<NV>>>;

// =================================| Root node initialiser class |=================================

template <int NV> struct instance: public script_fx1_impl::script_fx1_t_<NV>
{
	
	struct metadata
	{
		static const int NumTables = 3;
		static const int NumSliderPacks = 0;
		static const int NumAudioFiles = 0;
		static const int NumFilters = 0;
		static const int NumDisplayBuffers = 3;
		
		SNEX_METADATA_ID(script_fx1);
		SNEX_METADATA_NUM_CHANNELS(2);
		SNEX_METADATA_ENCODED_PARAMETERS(172)
		{
			0x005B, 0x0000, 0x4200, 0x6E61, 0x3164, 0x0000, 0xA000, 0x0041, 
            0x9C40, 0x2846, 0x8BD5, 0x1A43, 0x6B6C, 0x003E, 0x0000, 0x5B00, 
            0x0001, 0x0000, 0x6142, 0x646E, 0x0032, 0x0000, 0x41A0, 0x4000, 
            0x469C, 0xB916, 0x44EA, 0x6C1A, 0x3E6B, 0x0000, 0x0000, 0x025B, 
            0x0000, 0x4200, 0x6E61, 0x3364, 0x0000, 0xA000, 0x0041, 0x9C40, 
            0x4646, 0x1C37, 0x1A46, 0x6B6C, 0x003E, 0x0000, 0x5B00, 0x0003, 
            0x0000, 0x6957, 0x7464, 0x3168, 0x0000, 0x0000, 0x0000, 0x0000, 
            0x0040, 0x8000, 0x003F, 0x8000, 0x0A3F, 0x23D7, 0x5B3C, 0x0004, 
            0x0000, 0x6957, 0x7464, 0x3268, 0x0000, 0x0000, 0x0000, 0x0000, 
            0x0040, 0x8000, 0x003F, 0x8000, 0x0A3F, 0x23D7, 0x5B3C, 0x0005, 
            0x0000, 0x6957, 0x7464, 0x3368, 0x0000, 0x0000, 0x0000, 0x0000, 
            0x0040, 0x8000, 0x003F, 0x8000, 0x0A3F, 0x23D7, 0x5B3C, 0x0006, 
            0x0000, 0x6147, 0x6E69, 0x0031, 0x0000, 0xC2C8, 0x0000, 0x4190, 
            0x0000, 0x0000, 0x833E, 0x40AD, 0xCCCD, 0x3DCC, 0x075B, 0x0000, 
            0x4700, 0x6961, 0x326E, 0x0000, 0xC800, 0x00C2, 0x9000, 0x0041, 
            0x0000, 0x3E00, 0xAD83, 0xCD40, 0xCCCC, 0x5B3D, 0x0008, 0x0000, 
            0x6147, 0x6E69, 0x0033, 0x0000, 0xC2C8, 0x0000, 0x4190, 0x0000, 
            0x0000, 0x833E, 0x40AD, 0xCCCD, 0x3DCC, 0x095B, 0x0000, 0x4D00, 
            0x6E6F, 0x006F, 0x0000, 0x0000, 0x0000, 0x3F80, 0x0000, 0x3F80, 
            0x0000, 0x3F80, 0x0000, 0x3F80, 0x0A5B, 0x0000, 0x4700, 0x6961, 
            0x306E, 0x0000, 0xC800, 0x00C2, 0x9000, 0x0041, 0x0000, 0x3E00, 
            0xAD83, 0xCD40, 0xCCCC, 0x003D
		};
	};
	
	instance()
	{
		// Node References -------------------------------------------------------------------------
		
		auto& freq_split5 = this->getT(0);                                             // script_fx1_impl::freq_split5_t<NV>
		auto& band1 = this->getT(0).getT(0);                                           // script_fx1_impl::band1_t<NV>
		auto& lr1_1 = this->getT(0).getT(0).getT(0);                                   // jdsp::jlinkwitzriley
		auto& lr1_2 = this->getT(0).getT(0).getT(1);                                   // jdsp::jlinkwitzriley
		auto& lr1_3 = this->getT(0).getT(0).getT(2);                                   // jdsp::jlinkwitzriley
		auto& dummy1 = this->getT(0).getT(0).getT(3);                                  // math::mul<NV>
		auto& softbypass_switch3 = this->getT(0).getT(0).getT(4);                      // script_fx1_impl::softbypass_switch3_t<NV>
		auto& gain3 = this->getT(0).getT(0).getT(4).getT(0);                           // core::gain<NV>
		auto& switcher = this->getT(0).getT(0).getT(4).getT(1);                        // script_fx1_impl::switcher_t<NV>
		auto& sb_container = this->getT(0).getT(0).getT(4).getT(2);                    // script_fx1_impl::sb_container_t<NV>
		auto& sb1 = this->getT(0).getT(0).getT(4).getT(2).getT(0);                     // script_fx1_impl::sb1_t<NV>
		auto& dummy = this->getT(0).getT(0).getT(4).getT(2).getT(0).getT(0);           // math::mul<NV>
		auto& sb2 = this->getT(0).getT(0).getT(4).getT(2).getT(1);                     // script_fx1_impl::sb2_t<NV>
		auto& dummy5 = this->getT(0).getT(0).getT(4).getT(2).getT(1).getT(0);          // math::mul<NV>
		auto& split = this->getT(0).getT(0).getT(4).getT(2).getT(1).getT(1);           // script_fx1_impl::split_t
		auto& matrix = this->getT(0).getT(0).getT(4).getT(2).getT(1).getT(1).getT(0);  // routing::matrix<matrix_t_matrix>
		auto& matrix1 = this->getT(0).getT(0).getT(4).getT(2).getT(1).getT(1).getT(1); // routing::matrix<matrix1_t_matrix>
		auto& band2 = this->getT(0).getT(1);                                           // script_fx1_impl::band2_t<NV>
		auto& lr2_1 = this->getT(0).getT(1).getT(0);                                   // jdsp::jlinkwitzriley
		auto& lr2_2 = this->getT(0).getT(1).getT(1);                                   // jdsp::jlinkwitzriley
		auto& lr2_3 = this->getT(0).getT(1).getT(2);                                   // jdsp::jlinkwitzriley
		auto& faust = this->getT(0).getT(1).getT(3);                                   // project::StereoWidenerDSP<NV>
		auto& gain = this->getT(0).getT(1).getT(4);                                    // core::gain<NV>
		auto& dummy2 = this->getT(0).getT(1).getT(5);                                  // math::mul<NV>
		auto& goniometer = this->getT(0).getT(1).getT(6);                              // script_fx1_impl::goniometer_t
		auto& cable_table = this->getT(0).getT(1).getT(7);                             // script_fx1_impl::cable_table_t
		auto& band3 = this->getT(0).getT(2);                                           // script_fx1_impl::band3_t<NV>
		auto& lr3_1 = this->getT(0).getT(2).getT(0);                                   // jdsp::jlinkwitzriley
		auto& lr3_2 = this->getT(0).getT(2).getT(1);                                   // jdsp::jlinkwitzriley
		auto& lr3_3 = this->getT(0).getT(2).getT(2);                                   // jdsp::jlinkwitzriley
		auto& faust1 = this->getT(0).getT(2).getT(3);                                  // project::StereoWidenerDSP<NV>
		auto& gain1 = this->getT(0).getT(2).getT(4);                                   // core::gain<NV>
		auto& dummy3 = this->getT(0).getT(2).getT(5);                                  // math::mul<NV>
		auto& goniometer1 = this->getT(0).getT(2).getT(6);                             // script_fx1_impl::goniometer1_t
		auto& cable_table1 = this->getT(0).getT(2).getT(7);                            // script_fx1_impl::cable_table1_t
		auto& band4 = this->getT(0).getT(3);                                           // script_fx1_impl::band4_t<NV>
		auto& lr4_1 = this->getT(0).getT(3).getT(0);                                   // jdsp::jlinkwitzriley
		auto& lr4_2 = this->getT(0).getT(3).getT(1);                                   // jdsp::jlinkwitzriley
		auto& lr4_3 = this->getT(0).getT(3).getT(2);                                   // jdsp::jlinkwitzriley
		auto& faust2 = this->getT(0).getT(3).getT(3);                                  // project::StereoWidenerDSP<NV>
		auto& gain2 = this->getT(0).getT(3).getT(4);                                   // core::gain<NV>
		auto& dummy4 = this->getT(0).getT(3).getT(5);                                  // math::mul<NV>
		auto& goniometer2 = this->getT(0).getT(3).getT(6);                             // script_fx1_impl::goniometer2_t
		auto& cable_table2 = this->getT(0).getT(3).getT(7);                            // script_fx1_impl::cable_table2_t
		
		// Parameter Connections -------------------------------------------------------------------
		
		softbypass_switch3.getParameterT(0).connectT(0, switcher); // Switch -> switcher::Value
		auto& Band1_p = freq_split5.getParameterT(0);
		Band1_p.connectT(0, lr1_1);       // Band1 -> lr1_1::Frequency
		Band1_p.connectT(1, lr2_1);       // Band1 -> lr2_1::Frequency
		Band1_p.connectT(2, lr3_1);       // Band1 -> lr3_1::Frequency
		Band1_p.connectT(3, lr4_1);       // Band1 -> lr4_1::Frequency
		Band1_p.connectT(4, cable_table); // Band1 -> cable_table::Value
		
		auto& Band2_p = freq_split5.getParameterT(1);
		Band2_p.connectT(0, lr1_2);        // Band2 -> lr1_2::Frequency
		Band2_p.connectT(1, lr2_2);        // Band2 -> lr2_2::Frequency
		Band2_p.connectT(2, lr3_2);        // Band2 -> lr3_2::Frequency
		Band2_p.connectT(3, lr4_2);        // Band2 -> lr4_2::Frequency
		Band2_p.connectT(4, cable_table1); // Band2 -> cable_table1::Value
		
		auto& Band3_p = freq_split5.getParameterT(2);
		Band3_p.connectT(0, lr1_3);                      // Band3 -> lr1_3::Frequency
		Band3_p.connectT(1, lr2_3);                      // Band3 -> lr2_3::Frequency
		Band3_p.connectT(2, lr3_3);                      // Band3 -> lr3_3::Frequency
		Band3_p.connectT(3, lr4_3);                      // Band3 -> lr4_3::Frequency
		Band3_p.connectT(4, cable_table2);               // Band3 -> cable_table2::Value
		this->getParameterT(0).connectT(0, freq_split5); // Band1 -> freq_split5::Band1
		
		this->getParameterT(1).connectT(0, freq_split5); // Band2 -> freq_split5::Band2
		
		this->getParameterT(2).connectT(0, freq_split5); // Band3 -> freq_split5::Band3
		
		this->getParameterT(3).connectT(0, faust); // Width1 -> faust::width
		
		this->getParameterT(4).connectT(0, faust1); // Width2 -> faust1::width
		
		this->getParameterT(5).connectT(0, faust2); // Width3 -> faust2::width
		
		this->getParameterT(6).connectT(0, gain); // Gain1 -> gain::Gain
		
		this->getParameterT(7).connectT(0, gain1); // Gain2 -> gain1::Gain
		
		this->getParameterT(8).connectT(0, gain2); // Gain3 -> gain2::Gain
		
		this->getParameterT(9).connectT(0, softbypass_switch3); // Mono -> softbypass_switch3::Switch
		
		this->getParameterT(10).connectT(0, gain3); // Gain0 -> gain3::Gain
		
		// Modulation Connections ------------------------------------------------------------------
		
		auto& switcher_p = switcher.getWrappedObject().getParameter();
		switcher_p.getParameterT(0).connectT(0, sb1); // switcher -> sb1::Bypassed
		switcher_p.getParameterT(1).connectT(0, sb2); // switcher -> sb2::Bypassed
		
		// Default Values --------------------------------------------------------------------------
		
		; // freq_split5::Band1 is automated
		; // freq_split5::Band2 is automated
		; // freq_split5::Band3 is automated
		
		;                           // lr1_1::Frequency is automated
		lr1_1.setParameterT(1, 0.); // jdsp::jlinkwitzriley::Type
		
		;                           // lr1_2::Frequency is automated
		lr1_2.setParameterT(1, 2.); // jdsp::jlinkwitzriley::Type
		
		;                           // lr1_3::Frequency is automated
		lr1_3.setParameterT(1, 2.); // jdsp::jlinkwitzriley::Type
		
		dummy1.setParameterT(0, 1.); // math::mul::Value
		
		; // softbypass_switch3::Switch is automated
		
		;                            // gain3::Gain is automated
		gain3.setParameterT(1, 20.); // core::gain::Smoothing
		gain3.setParameterT(2, 0.);  // core::gain::ResetValue
		
		; // switcher::Value is automated
		
		dummy.setParameterT(0, 1.); // math::mul::Value
		
		dummy5.setParameterT(0, 1.); // math::mul::Value
		
		;                           // lr2_1::Frequency is automated
		lr2_1.setParameterT(1, 1.); // jdsp::jlinkwitzriley::Type
		
		;                           // lr2_2::Frequency is automated
		lr2_2.setParameterT(1, 0.); // jdsp::jlinkwitzriley::Type
		
		;                           // lr2_3::Frequency is automated
		lr2_3.setParameterT(1, 2.); // jdsp::jlinkwitzriley::Type
		
		; // faust::width is automated
		
		;                           // gain::Gain is automated
		gain.setParameterT(1, 20.); // core::gain::Smoothing
		gain.setParameterT(2, 0.);  // core::gain::ResetValue
		
		dummy2.setParameterT(0, 1.); // math::mul::Value
		
		; // cable_table::Value is automated
		
		;                           // lr3_1::Frequency is automated
		lr3_1.setParameterT(1, 2.); // jdsp::jlinkwitzriley::Type
		
		;                           // lr3_2::Frequency is automated
		lr3_2.setParameterT(1, 1.); // jdsp::jlinkwitzriley::Type
		
		;                           // lr3_3::Frequency is automated
		lr3_3.setParameterT(1, 0.); // jdsp::jlinkwitzriley::Type
		
		; // faust1::width is automated
		
		;                            // gain1::Gain is automated
		gain1.setParameterT(1, 20.); // core::gain::Smoothing
		gain1.setParameterT(2, 0.);  // core::gain::ResetValue
		
		dummy3.setParameterT(0, 1.); // math::mul::Value
		
		; // cable_table1::Value is automated
		
		;                           // lr4_1::Frequency is automated
		lr4_1.setParameterT(1, 2.); // jdsp::jlinkwitzriley::Type
		
		;                           // lr4_2::Frequency is automated
		lr4_2.setParameterT(1, 2.); // jdsp::jlinkwitzriley::Type
		
		;                           // lr4_3::Frequency is automated
		lr4_3.setParameterT(1, 1.); // jdsp::jlinkwitzriley::Type
		
		; // faust2::width is automated
		
		;                            // gain2::Gain is automated
		gain2.setParameterT(1, 20.); // core::gain::Smoothing
		gain2.setParameterT(2, 0.);  // core::gain::ResetValue
		
		dummy4.setParameterT(0, 1.); // math::mul::Value
		
		; // cable_table2::Value is automated
		
		this->setParameterT(0, 279.665);
		this->setParameterT(1, 1877.78);
		this->setParameterT(2, 9997.82);
		this->setParameterT(3, 1.);
		this->setParameterT(4, 1.);
		this->setParameterT(5, 1.);
		this->setParameterT(6, 0.);
		this->setParameterT(7, 0.);
		this->setParameterT(8, 0.);
		this->setParameterT(9, 1.);
		this->setParameterT(10, 0.);
		this->setExternalData({}, -1);
	}
	~instance() override
	{
		// Cleanup external data references --------------------------------------------------------
		
		this->setExternalData({}, -1);
	}
	
	static constexpr bool isPolyphonic() { return NV > 1; };
	
	static constexpr bool hasTail() { return true; };
	
	static constexpr bool isSuspendedOnSilence() { return false; };
	
	void setExternalData(const ExternalData& b, int index)
	{
		// External Data Connections ---------------------------------------------------------------
		
		this->getT(0).getT(1).getT(6).setExternalData(b, index); // script_fx1_impl::goniometer_t
		this->getT(0).getT(1).getT(7).setExternalData(b, index); // script_fx1_impl::cable_table_t
		this->getT(0).getT(2).getT(6).setExternalData(b, index); // script_fx1_impl::goniometer1_t
		this->getT(0).getT(2).getT(7).setExternalData(b, index); // script_fx1_impl::cable_table1_t
		this->getT(0).getT(3).getT(6).setExternalData(b, index); // script_fx1_impl::goniometer2_t
		this->getT(0).getT(3).getT(7).setExternalData(b, index); // script_fx1_impl::cable_table2_t
	}
};
}

#undef getT
#undef connectT
#undef setParameterT
#undef setParameterWT
#undef getParameterT
// ======================================| Public Definition |======================================

namespace project
{
// polyphonic template declaration

template <int NV>
using script_fx1 = wrap::node<script_fx1_impl::instance<NV>>;
}


