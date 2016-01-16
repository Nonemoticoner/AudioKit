//
//  AKCoreInstrument.swift
//  AudioKit
//
//  Created by Aurelius Prochazka.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import AudioKit

/// A wrapper for AKCore to make it a playable as a polyphonic instrument.
class CoreInstrument: AKPolyphonicInstrument {
    
    var offset1 = 0 {
        didSet {
            for i in 0..<activeVoices.count {
                let coreVoice = activeVoices[i] as! CoreVoice
                let note = activeNotes[i] + offset1
                coreVoice.sineVCO1.frequency     = note.midiNoteToFrequency()
                coreVoice.sawtoothVCO1.frequency = note.midiNoteToFrequency()
                coreVoice.squareVCO1.frequency   = note.midiNoteToFrequency()
                coreVoice.triangleVCO1.frequency = note.midiNoteToFrequency()
            }
        }
    }
    
    var offset2 = 0 {
        didSet {
            for i in 0..<activeVoices.count {
                let coreVoice = activeVoices[i] as! CoreVoice
                let note = activeNotes[i] + offset2
                coreVoice.sineVCO2.frequency     = note.midiNoteToFrequency()
                coreVoice.sawtoothVCO2.frequency = note.midiNoteToFrequency()
                coreVoice.squareVCO2.frequency   = note.midiNoteToFrequency()
                coreVoice.triangleVCO2.frequency = note.midiNoteToFrequency()
            }
        }
    }
    
    
    var subOscMix = 0.0 {
        didSet {
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.subOscMixer.volume = subOscMix
            }
        }
    }
    
    var fmOscMix = 0.0 {
        didSet {
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.fmOscMixer.volume = fmOscMix
            }
        }
    }
    
    var noiseMix = 0.0 {
        didSet {
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.noiseMixer.volume = noiseMix
            }
        }
    }

    var detune: Double = 0.0 {
        didSet {
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.sawtoothVCO2.detuning = detune
                coreVoice.sineVCO2.detuning     = detune
                coreVoice.squareVCO2.detuning   = detune
                coreVoice.triangleVCO2.detuning = detune
            }
        }
    }
    var fmMod: Double = 1 {
        didSet {
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                // Matt Fecher: Do what you'd like to do with this value, I have no clue
                //                coreVoice.fmOscillator.carrierMultiplier = carrierMultiplier
                //                coreVoice.fmOscillator.modulatingMultiplier = modulatingMultiplier
                coreVoice.fmOscillator.modulationIndex = fmMod
            }
        }
    }
    
    var vco12Mix: Double = 0.5 {
        didSet {
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.vco12Mixer.balance = vco12Mix
            }
        }
    }
    
    var pulseWidth: Double = 0.5 {
        didSet {
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.squareVCO1.pulseWidth = pulseWidth
                coreVoice.squareVCO2.pulseWidth = pulseWidth
            }
        }
    }
    
    /// Attack time
    var attackDuration: Double = 0.1 {
        didSet {
            if attackDuration < 0.02 { attackDuration = 0.02 }
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.adsr.attackDuration = attackDuration
            }
        }
    }
    /// Decay time
    var decayDuration: Double = 0.1 {
        didSet {
            if decayDuration < 0.02 { decayDuration = 0.02 }
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.adsr.decayDuration = decayDuration
            }
        }
    }
    /// Sustain Level
    var sustainLevel: Double = 0.66 {
        didSet {
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.adsr.sustainLevel = sustainLevel
            }
        }
    }
    /// Release time
    var releaseDuration: Double = 0.5 {
        didSet {
            if releaseDuration < 0.02 { releaseDuration = 0.02 }
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.adsr.releaseDuration = releaseDuration
            }
        }
    }

    var selectedVCO1Waveform = 0 {
        didSet {
            vco1Amplitudes = [0.0,0,0,0]
            vco1Amplitudes[selectedVCO1Waveform] = 1.0
            
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.sawtoothVCO1Mixer.volume = vco1Amplitudes[0]
                coreVoice.squareVCO1Mixer.volume   = vco1Amplitudes[1]
                coreVoice.sineVCO1Mixer.volume     = vco1Amplitudes[2]
                coreVoice.triangleVCO1Mixer.volume = vco1Amplitudes[3]
            }
        }
    }
    
    var selectedVCO2Waveform = 0 {
        didSet {
            vco2Amplitudes = [0.0,0,0,0]
            vco2Amplitudes[selectedVCO2Waveform] = 1.0
            
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                coreVoice.sawtoothVCO2Mixer.volume = vco2Amplitudes[0]
                coreVoice.squareVCO2Mixer.volume   = vco2Amplitudes[1]
                coreVoice.sineVCO2Mixer.volume     = vco2Amplitudes[2]
                coreVoice.triangleVCO2Mixer.volume = vco2Amplitudes[3]
            }
        }
    }
    
    var vco1Amplitudes = [1.0,0,0,0]
    var vco2Amplitudes = [1.0,0,0,0]
    
    var vco1On = false {
        didSet {
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                if vco1On {
                    coreVoice.vco1Mixer.volume = 1
                } else {
                    coreVoice.vco1Mixer.volume = 0
                }
            }
        }
    }
    var vco2On = false {
        didSet {
            for voice in voices {
                let coreVoice = voice as! CoreVoice
                if vco2On {
                    coreVoice.vco2Mixer.volume = 1
                } else {
                    coreVoice.vco2Mixer.volume = 0
                }
            }
        }
    }

    
    /// Instantiate the Instrument
    ///
    /// - parameter voiceCount: Maximum number of voices that will be required
    ///
    init(voiceCount: Int) {
        super.init(voice: CoreVoice(), voiceCount: voiceCount)

        let sourceCount = 11
        amplitude = 1.0 /  Double(sourceCount * voiceCount)
        
    }
    
    /// Start a given voice playing a note.
    ///
    /// - parameter voice: Voice to start
    /// - parameter note: MIDI Note Number to start
    /// - parameter velocity: MIDI Velocity (0-127) to trigger the note at
    ///
    override func playVoice(voice: AKVoice, note: Int, velocity: Int) {
        let coreVoice = voice as! CoreVoice
        
        let commonAmplitude = Double(velocity)/127.0
        
        coreVoice.sawtoothVCO1.amplitude = commonAmplitude
        coreVoice.squareVCO1.amplitude   = commonAmplitude
        coreVoice.sineVCO1.amplitude     = commonAmplitude
        coreVoice.triangleVCO1.amplitude = commonAmplitude
        

        coreVoice.sawtoothVCO2.amplitude = commonAmplitude
        coreVoice.squareVCO2.amplitude   = commonAmplitude
        coreVoice.sineVCO2.amplitude     = commonAmplitude
        coreVoice.triangleVCO2.amplitude = commonAmplitude
        
        coreVoice.subOsc.amplitude       = commonAmplitude
        coreVoice.fmOscillator.amplitude = commonAmplitude
        coreVoice.noise.amplitude        = commonAmplitude
        
        let vco1Frequency = (note + offset1).midiNoteToFrequency()
        
        coreVoice.sawtoothVCO1.frequency = vco1Frequency
        coreVoice.sineVCO1.frequency     = vco1Frequency
        coreVoice.squareVCO1.frequency   = vco1Frequency
        coreVoice.triangleVCO1.frequency = vco1Frequency
        
        let vco2Frequency = (note + offset2).midiNoteToFrequency()
        
        coreVoice.sawtoothVCO2.frequency = vco2Frequency
        coreVoice.sineVCO2.frequency     = vco2Frequency
        coreVoice.squareVCO2.frequency   = vco2Frequency
        coreVoice.triangleVCO2.frequency = vco2Frequency
        
        coreVoice.subOsc.frequency = (note - 12).midiNoteToFrequency()
        coreVoice.fmOscillator.baseFrequency = note.midiNoteToFrequency()
        
        coreVoice.start()
    }
    
    /// Stop a given voice playing a note.
    ///
    /// - parameter voice: Voice to stop
    /// - parameter note: MIDI Note Number to stop
    ///
    override func stopVoice(voice: AKVoice, note: Int) {
        let coreVoice = voice as! CoreVoice
        coreVoice.stop()
    }
    
//    override func panic() {
//        for voice in voices {
//            let coreVoice = voice as! CoreVoice
//            coreVoice.stop()
//            coreVoice.fmOscillator.stop()
//            coreVoice.sawtoothVCO1.stop()
//            coreVoice.sineVCO1.stop()
//            coreVoice.squareVCO1.stop()
//            coreVoice.triangleVCO1.stop()
//            coreVoice.sawtoothVCO2.stop()
//            coreVoice.sineVCO2.stop()
//            coreVoice.squareVCO2.stop()
//            coreVoice.triangleVCO2.stop()
//            coreVoice.noise.stop()
//            coreVoice.subOsc.stop()
//            coreVoice.adsr.stop()
//            active
//            activeNotes.removeAll()
//            activeVoices.removeAll()
//        }
//    }
    
}
