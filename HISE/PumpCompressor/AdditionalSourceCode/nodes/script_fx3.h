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

namespace script_fx3_impl
{
// ==============================| Node & Parameter type declarations |==============================

template <int NV>
using band1_t = container::chain<parameter::empty, 
                                 wrap::fix<2, jdsp::jlinkwitzriley>, 
                                 math::mul<NV>>;

DECLARE_PARAMETER_RANGE_SKEW(dry_wet_mixer_c0Range, 
                             -100., 
                             0., 
                             5.42227);

template <int NV>
using dry_wet_mixer_c0 = parameter::from0To1<core::gain<NV>, 
                                             0, 
                                             dry_wet_mixer_c0Range>;

template <int NV> using dry_wet_mixer_c1 = dry_wet_mixer_c0<NV>;

template <int NV>
using dry_wet_mixer_multimod = parameter::list<dry_wet_mixer_c0<NV>, dry_wet_mixer_c1<NV>>;

template <int NV>
using dry_wet_mixer_t = control::xfader<dry_wet_mixer_multimod<NV>, 
                                        faders::linear>;

template <int NV>
using dry_path_t = container::chain<parameter::empty, 
                                    wrap::fix<2, dry_wet_mixer_t<NV>>, 
                                    core::gain<NV>>;

using global_cable1_t_index = runtime_target::indexers::fix_hash<-1810961338>;
using converter1_mod = parameter::plain<routing::global_cable<global_cable1_t_index, parameter::empty>, 
                                        0>;
using converter1_t = control::converter<converter1_mod, 
                                        conversion_logic::db2gain>;

using global_cable_t_index = runtime_target::indexers::fix_hash<-299565635>;
using converter_mod = parameter::plain<routing::global_cable<global_cable_t_index, parameter::empty>, 
                                       0>;
using converter_t = control::converter<converter_mod, 
                                       conversion_logic::db2gain>;
using faust_multimod = parameter::list<parameter::plain<converter1_t, 0>, 
                                       parameter::plain<converter_t, 0>>;

template <int NV>
using faust_t = project::CompressorDSP1<NV, faust_multimod>;
using global_cable2_t_index = runtime_target::indexers::fix_hash<1953399788>;

template <int NV>
using tempo_sync_mod = parameter::chain<ranges::Identity, 
                                        parameter::plain<faust_t<NV>, 5>, 
                                        parameter::plain<routing::global_cable<global_cable2_t_index, parameter::empty>, 0>>;

template <int NV>
using tempo_sync_t = wrap::mod<tempo_sync_mod<NV>, 
                               control::tempo_sync<NV>>;

using global_cable3_t_index = runtime_target::indexers::fix_hash<-480085397>;

template <int NV>
using tempo_sync1_mod = parameter::chain<ranges::Identity, 
                                         parameter::plain<faust_t<NV>, 6>, 
                                         parameter::plain<routing::global_cable<global_cable3_t_index, parameter::empty>, 0>>;

template <int NV>
using tempo_sync1_t = wrap::mod<tempo_sync1_mod<NV>, 
                                control::tempo_sync<NV>>;

template <int NV>
using wet_path_t = container::chain<parameter::empty, 
                                    wrap::fix<2, math::mul<NV>>, 
                                    tempo_sync_t<NV>, 
                                    tempo_sync1_t<NV>, 
                                    faust_t<NV>, 
                                    core::gain<NV>>;

namespace dry_wet1_t_parameters
{
}

template <int NV>
using dry_wet1_t = container::split<parameter::plain<script_fx3_impl::dry_wet_mixer_t<NV>, 0>, 
                                    wrap::fix<2, dry_path_t<NV>>, 
                                    wet_path_t<NV>>;

template <int NV>
using band2_t = container::chain<parameter::empty, 
                                 wrap::fix<2, jdsp::jlinkwitzriley>, 
                                 dry_wet1_t<NV>, 
                                 math::mul<NV>>;

namespace freq_split3_t_parameters
{
DECLARE_PARAMETER_RANGE_SKEW(Band1_0Range, 
                             20., 
                             20000., 
                             0.229905);

using Band1_0 = parameter::from0To1<jdsp::jlinkwitzriley, 
                                    0, 
                                    Band1_0Range>;

using Band1_1 = Band1_0;

using Band1 = parameter::chain<ranges::Identity, 
                               Band1_0, 
                               Band1_1>;

}

template <int NV>
using freq_split3_t = container::split<freq_split3_t_parameters::Band1, 
                                       wrap::fix<2, band1_t<NV>>, 
                                       band2_t<NV>>;

namespace script_fx3_t_parameters
{
// Parameter list for script_fx3_impl::script_fx3_t ------------------------------------------------

template <int NV>
using Attack = parameter::plain<script_fx3_impl::tempo_sync_t<NV>, 
                                0>;
template <int NV>
using Release = parameter::plain<script_fx3_impl::tempo_sync1_t<NV>, 
                                 0>;
template <int NV>
using Ratio = parameter::plain<script_fx3_impl::faust_t<NV>, 
                               1>;
template <int NV>
using Threshold = parameter::plain<script_fx3_impl::faust_t<NV>, 
                                   2>;
template <int NV>
using MakeupGain = parameter::plain<script_fx3_impl::faust_t<NV>, 
                                    7>;
template <int NV>
using ChannelLink = parameter::plain<script_fx3_impl::faust_t<NV>, 
                                     8>;
template <int NV>
using AttackMultiplier = parameter::plain<script_fx3_impl::tempo_sync_t<NV>, 
                                          1>;
template <int NV>
using ReleaseMultiplier = parameter::plain<script_fx3_impl::tempo_sync1_t<NV>, 
                                           1>;
template <int NV>
using Mix = parameter::plain<script_fx3_impl::dry_wet1_t<NV>, 
                             0>;
template <int NV>
using Knee = parameter::plain<script_fx3_impl::faust_t<NV>, 
                              0>;
template <int NV>
using SCFilter = parameter::plain<script_fx3_impl::freq_split3_t<NV>, 
                                  0>;
template <int NV>
using UnsyncAttack = parameter::plain<script_fx3_impl::faust_t<NV>, 
                                      3>;
template <int NV>
using UnsyncRelease = parameter::plain<script_fx3_impl::faust_t<NV>, 
                                       4>;
template <int NV>
using script_fx3_t_plist = parameter::list<Attack<NV>, 
                                           Release<NV>, 
                                           Ratio<NV>, 
                                           Threshold<NV>, 
                                           MakeupGain<NV>, 
                                           ChannelLink<NV>, 
                                           AttackMultiplier<NV>, 
                                           ReleaseMultiplier<NV>, 
                                           Mix<NV>, 
                                           Knee<NV>, 
                                           SCFilter<NV>, 
                                           UnsyncAttack<NV>, 
                                           UnsyncRelease<NV>>;
}

template <int NV>
using script_fx3_t_ = container::chain<script_fx3_t_parameters::script_fx3_t_plist<NV>, 
                                       wrap::fix<2, freq_split3_t<NV>>, 
                                       routing::global_cable<global_cable2_t_index, parameter::empty>, 
                                       routing::global_cable<global_cable3_t_index, parameter::empty>, 
                                       converter_t, 
                                       converter1_t, 
                                       routing::global_cable<global_cable1_t_index, parameter::empty>, 
                                       routing::global_cable<global_cable_t_index, parameter::empty>>;

// =================================| Root node initialiser class |=================================

template <int NV> struct instance: public script_fx3_impl::script_fx3_t_<NV>
{
	
	struct metadata
	{
		static const int NumTables = 0;
		static const int NumSliderPacks = 0;
		static const int NumAudioFiles = 0;
		static const int NumFilters = 0;
		static const int NumDisplayBuffers = 0;
		
		SNEX_METADATA_ID(script_fx3);
		SNEX_METADATA_NUM_CHANNELS(2);
		SNEX_METADATA_ENCODED_PARAMETERS(230)
		{
			0x005B, 0x0000, 0x4100, 0x7474, 0x6361, 0x006B, 0x0000, 0x0000, 
            0x0000, 0x41D8, 0x0000, 0x3F80, 0x0000, 0x3F80, 0x0000, 0x3F80, 
            0x015B, 0x0000, 0x5200, 0x6C65, 0x6165, 0x6573, 0x0000, 0x0000, 
            0x0000, 0xD800, 0x0041, 0x8000, 0x003F, 0x8000, 0x003F, 0x8000, 
            0x5B3F, 0x0002, 0x0000, 0x6152, 0x6974, 0x006F, 0x0000, 0x3F80, 
            0x0000, 0x41A0, 0x6667, 0x415E, 0x0000, 0x3F80, 0xCCCD, 0x3DCC, 
            0x035B, 0x0000, 0x5400, 0x7268, 0x7365, 0x6F68, 0x646C, 0x0000, 
            0xC000, 0x00C2, 0x2000, 0xCD41, 0x34CC, 0x00C2, 0x8000, 0xCD3F, 
            0xCCCC, 0x5B3D, 0x0004, 0x0000, 0x614D, 0x656B, 0x7075, 0x6147, 
            0x6E69, 0x0000, 0xC000, 0x00C2, 0xC000, 0x0042, 0x8000, 0x003F, 
            0x8000, 0xCD3F, 0xCCCC, 0x5B3D, 0x0005, 0x0000, 0x6843, 0x6E61, 
            0x656E, 0x4C6C, 0x6E69, 0x006B, 0x0000, 0x0000, 0x0000, 0x42C8, 
            0x0000, 0x3F80, 0x0000, 0x3F80, 0x0000, 0x3F80, 0x065B, 0x0000, 
            0x4100, 0x7474, 0x6361, 0x4D6B, 0x6C75, 0x6974, 0x6C70, 0x6569, 
            0x0072, 0x0000, 0x3F80, 0x0000, 0x4180, 0x0000, 0x3F80, 0x0000, 
            0x3F80, 0x0000, 0x3F80, 0x075B, 0x0000, 0x5200, 0x6C65, 0x6165, 
            0x6573, 0x754D, 0x746C, 0x7069, 0x696C, 0x7265, 0x0000, 0x8000, 
            0x003F, 0x8000, 0x0041, 0x8000, 0x003F, 0x8000, 0x003F, 0x8000, 
            0x5B3F, 0x0008, 0x0000, 0x694D, 0x0078, 0x0000, 0x0000, 0x0000, 
            0x3F80, 0x0000, 0x3F80, 0x0000, 0x3F80, 0x0000, 0x0000, 0x095B, 
            0x0000, 0x4B00, 0x656E, 0x0065, 0x0000, 0x0000, 0x0000, 0x41A0, 
            0x999A, 0x40D9, 0x0000, 0x3F80, 0xCCCD, 0x3DCC, 0x0A5B, 0x0000, 
            0x5300, 0x4643, 0x6C69, 0x6574, 0x0072, 0x0000, 0x41A0, 0x4000, 
            0x469C, 0x0000, 0x3F80, 0x6C1A, 0x3E6B, 0x0000, 0x0000, 0x0B5B, 
            0x0000, 0x5500, 0x736E, 0x6E79, 0x4163, 0x7474, 0x6361, 0x006B, 
            0x0000, 0xC47A, 0x0000, 0x447A, 0x0000, 0x3F80, 0x0000, 0x3F80, 
            0xCCCD, 0x3DCC, 0x0C5B, 0x0000, 0x5500, 0x736E, 0x6E79, 0x5263, 
            0x6C65, 0x6165, 0x6573, 0x0000, 0x7A00, 0x00C4, 0x7A00, 0x0044, 
            0x8000, 0x003F, 0x8000, 0xCD3F, 0xCCCC, 0x003D
		};
	};
	
	instance()
	{
		// Node References -------------------------------------------------------------------------
		
		auto& freq_split3 = this->getT(0);                                   // script_fx3_impl::freq_split3_t<NV>
		auto& band1 = this->getT(0).getT(0);                                 // script_fx3_impl::band1_t<NV>
		auto& lr1_1 = this->getT(0).getT(0).getT(0);                         // jdsp::jlinkwitzriley
		auto& dummy1 = this->getT(0).getT(0).getT(1);                        // math::mul<NV>
		auto& band2 = this->getT(0).getT(1);                                 // script_fx3_impl::band2_t<NV>
		auto& lr2_1 = this->getT(0).getT(1).getT(0);                         // jdsp::jlinkwitzriley
		auto& dry_wet1 = this->getT(0).getT(1).getT(1);                      // script_fx3_impl::dry_wet1_t<NV>
		auto& dry_path = this->getT(0).getT(1).getT(1).getT(0);              // script_fx3_impl::dry_path_t<NV>
		auto& dry_wet_mixer = this->getT(0).getT(1).getT(1).getT(0).getT(0); // script_fx3_impl::dry_wet_mixer_t<NV>
		auto& dry_gain = this->getT(0).getT(1).getT(1).getT(0).getT(1);      // core::gain<NV>
		auto& wet_path = this->getT(0).getT(1).getT(1).getT(1);              // script_fx3_impl::wet_path_t<NV>
		auto& dummy = this->getT(0).getT(1).getT(1).getT(1).getT(0);         // math::mul<NV>
		auto& tempo_sync = this->getT(0).getT(1).getT(1).getT(1).getT(1);    // script_fx3_impl::tempo_sync_t<NV>
		auto& tempo_sync1 = this->getT(0).getT(1).getT(1).getT(1).getT(2);   // script_fx3_impl::tempo_sync1_t<NV>
		auto& faust = this->getT(0).getT(1).getT(1).getT(1).getT(3);         // script_fx3_impl::faust_t<NV>
		auto& wet_gain = this->getT(0).getT(1).getT(1).getT(1).getT(4);      // core::gain<NV>
		auto& dummy2 = this->getT(0).getT(1).getT(2);                        // math::mul<NV>
		auto& global_cable2 = this->getT(1);                                 // routing::global_cable<global_cable2_t_index, parameter::empty>
		auto& global_cable3 = this->getT(2);                                 // routing::global_cable<global_cable3_t_index, parameter::empty>
		auto& converter = this->getT(3);                                     // script_fx3_impl::converter_t
		auto& converter1 = this->getT(4);                                    // script_fx3_impl::converter1_t
		auto& global_cable1 = this->getT(5);                                 // routing::global_cable<global_cable1_t_index, parameter::empty>
		auto& global_cable = this->getT(6);                                  // routing::global_cable<global_cable_t_index, parameter::empty>
		
		// Parameter Connections -------------------------------------------------------------------
		
		dry_wet1.getParameterT(0).connectT(0, dry_wet_mixer); // DryWet -> dry_wet_mixer::Value
		auto& Band1_p = freq_split3.getParameterT(0);
		Band1_p.connectT(0, lr1_1);                     // Band1 -> lr1_1::Frequency
		Band1_p.connectT(1, lr2_1);                     // Band1 -> lr2_1::Frequency
		this->getParameterT(0).connectT(0, tempo_sync); // Attack -> tempo_sync::Tempo
		
		this->getParameterT(1).connectT(0, tempo_sync1); // Release -> tempo_sync1::Tempo
		
		this->getParameterT(2).connectT(0, faust); // Ratio -> faust::ratio
		
		this->getParameterT(3).connectT(0, faust); // Threshold -> faust::threshold
		
		this->getParameterT(4).connectT(0, faust); // MakeupGain -> faust::makeupgain
		
		this->getParameterT(5).connectT(0, faust); // ChannelLink -> faust::channellink
		
		this->getParameterT(6).connectT(0, tempo_sync); // AttackMultiplier -> tempo_sync::Multiplier
		
		this->getParameterT(7).connectT(0, tempo_sync1); // ReleaseMultiplier -> tempo_sync1::Multiplier
		
		this->getParameterT(8).connectT(0, dry_wet1); // Mix -> dry_wet1::DryWet
		
		this->getParameterT(9).connectT(0, faust); // Knee -> faust::knee
		
		this->getParameterT(10).connectT(0, freq_split3); // SCFilter -> freq_split3::Band1
		
		this->getParameterT(11).connectT(0, faust); // UnsyncAttack -> faust::AddRemoveAttack
		
		this->getParameterT(12).connectT(0, faust); // UnsyncRelease -> faust::AddRemoveRelease
		
		// Modulation Connections ------------------------------------------------------------------
		
		auto& dry_wet_mixer_p = dry_wet_mixer.getWrappedObject().getParameter();
		dry_wet_mixer_p.getParameterT(0).connectT(0, dry_gain);                  // dry_wet_mixer -> dry_gain::Gain
		dry_wet_mixer_p.getParameterT(1).connectT(0, wet_gain);                  // dry_wet_mixer -> wet_gain::Gain
		converter1.getWrappedObject().getParameter().connectT(0, global_cable1); // converter1 -> global_cable1::Value
		converter.getWrappedObject().getParameter().connectT(0, global_cable);   // converter -> global_cable::Value
		auto& faust_p = faust.getWrappedObject().getParameter();
		faust_p.getParameterT(0).connectT(0, converter1);      // faust -> converter1::Value
		faust_p.getParameterT(1).connectT(0, converter);       // faust -> converter::Value
		tempo_sync.getParameter().connectT(0, faust);          // tempo_sync -> faust::Attack
		tempo_sync.getParameter().connectT(1, global_cable2);  // tempo_sync -> global_cable2::Value
		tempo_sync1.getParameter().connectT(0, faust);         // tempo_sync1 -> faust::Release
		tempo_sync1.getParameter().connectT(1, global_cable3); // tempo_sync1 -> global_cable3::Value
		
		// Default Values --------------------------------------------------------------------------
		
		; // freq_split3::Band1 is automated
		
		;                           // lr1_1::Frequency is automated
		lr1_1.setParameterT(1, 0.); // jdsp::jlinkwitzriley::Type
		
		dummy1.setParameterT(0, 1.); // math::mul::Value
		
		;                           // lr2_1::Frequency is automated
		lr2_1.setParameterT(1, 1.); // jdsp::jlinkwitzriley::Type
		
		; // dry_wet1::DryWet is automated
		
		; // dry_wet_mixer::Value is automated
		
		;                               // dry_gain::Gain is automated
		dry_gain.setParameterT(1, 20.); // core::gain::Smoothing
		dry_gain.setParameterT(2, 0.);  // core::gain::ResetValue
		
		dummy.setParameterT(0, 1.); // math::mul::Value
		
		;                                // tempo_sync::Tempo is automated
		;                                // tempo_sync::Multiplier is automated
		tempo_sync.setParameterT(2, 1.); // control::tempo_sync::Enabled
		tempo_sync.setParameterT(3, 0.); // control::tempo_sync::UnsyncedTime
		
		;                                 // tempo_sync1::Tempo is automated
		;                                 // tempo_sync1::Multiplier is automated
		tempo_sync1.setParameterT(2, 1.); // control::tempo_sync::Enabled
		tempo_sync1.setParameterT(3, 0.); // control::tempo_sync::UnsyncedTime
		
		; // faust::knee is automated
		; // faust::ratio is automated
		; // faust::threshold is automated
		; // faust::AddRemoveAttack is automated
		; // faust::AddRemoveRelease is automated
		; // faust::Attack is automated
		; // faust::Release is automated
		; // faust::makeupgain is automated
		; // faust::channellink is automated
		
		;                               // wet_gain::Gain is automated
		wet_gain.setParameterT(1, 20.); // core::gain::Smoothing
		wet_gain.setParameterT(2, 0.);  // core::gain::ResetValue
		
		dummy2.setParameterT(0, 1.); // math::mul::Value
		
		; // global_cable2::Value is automated
		
		; // global_cable3::Value is automated
		
		; // converter::Value is automated
		
		; // converter1::Value is automated
		
		; // global_cable1::Value is automated
		
		; // global_cable::Value is automated
		
		this->setParameterT(0, 1.);
		this->setParameterT(1, 1.);
		this->setParameterT(2, 13.9);
		this->setParameterT(3, -45.);
		this->setParameterT(4, 1.);
		this->setParameterT(5, 1.);
		this->setParameterT(6, 1.);
		this->setParameterT(7, 1.);
		this->setParameterT(8, 1.);
		this->setParameterT(9, 6.8);
		this->setParameterT(10, 1.);
		this->setParameterT(11, 1.);
		this->setParameterT(12, 1.);
	}
	
	static constexpr bool isPolyphonic() { return NV > 1; };
	
	static constexpr bool isProcessingHiseEvent() { return true; };
	
	static constexpr bool hasTail() { return true; };
	
	static constexpr bool isSuspendedOnSilence() { return false; };
	
	void connectToRuntimeTarget(bool addConnection, const runtime_target::connection& c)
	{
		// Runtime target Connections --------------------------------------------------------------
		
		this->getT(1).connectToRuntimeTarget(addConnection, c); // routing::global_cable<global_cable2_t_index, parameter::empty>
		this->getT(2).connectToRuntimeTarget(addConnection, c); // routing::global_cable<global_cable3_t_index, parameter::empty>
		this->getT(5).connectToRuntimeTarget(addConnection, c); // routing::global_cable<global_cable1_t_index, parameter::empty>
		this->getT(6).connectToRuntimeTarget(addConnection, c); // routing::global_cable<global_cable_t_index, parameter::empty>
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
using script_fx3 = wrap::node<script_fx3_impl::instance<NV>>;
}


