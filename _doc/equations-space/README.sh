
# Demonstrates low bandwidth (9600bits), high framerate (60Hz), high resolution (0.25um), galactic scale (2.00ly diameter 8000 stars), high player count (>>122 players) netcode is simultaneously achievable.

# 27byte 'Complete' 2.00ly Diameter 0.25um Resolution Address
# 20byte 'Galactic' 2.00ly Diameter 10m Resolution Address
# 12byte 'Instance' 100km Diameter 0.25um Resolution Address



# Suggested parameters for experimental netcode.

currentAbsFramesPerSecond=5
currentRelFramesPerSecond=60
currentAbsFrameBytesPerBone=27
currentRelFrameBytesPerBone=2

# Theoretically, >5 million players could share a single 10Gbits server/WiFi6 connection for real-time VR multiplayer.





# Part of 'Ubiquitous Bash' . All equations are expected to run within a 'bash' shell having imported 'Ubiquitous Bash' functions through '_setupUbiquitous' or similar. Both 'qalculate' and 'octave' may be used as backends as appropriate.



# ### _Estimates_


# ### -Bandwidth-

currentByte=8


# Severely degraded and highly compressed conection between just two players.
currentBitsPerSecond=9600 ; currentBonesPerPlayer=4 ; currentRelFramesPerSecond=15 ; currentRelFrameBytesPerBone=2 ; currentAbsFramesPerSecond=2 ; currentAbsFrameBytesPerBone=12 ; currentByte=8 ; solve "("$currentBitsPerSecond" == (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentRelFramesPerSecond" * "$currentRelFrameBytesPerBone" * "$currentByte") + (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentAbsFramesPerSecond" * "$currentAbsFrameBytesPerBone" * "$currentByte"), \"currentPlayers\")"
# # solve(9600 = (("currentPlayers" * 4 * 30 * 2 * 8) + ("currentPlayers" * 4 * 3 * 33 * 8)), "currentPlayers") =
# # 5.5555556

currentBitsPerSecond=9600 ; currentBonesPerPlayer=4 ; currentRelFramesPerSecond=60 ; currentRelFrameBytesPerBone=2 ; currentAbsFramesPerSecond=5 ; currentAbsFrameBytesPerBone=27 ; currentByte=8 ; solve "("$currentBitsPerSecond" == (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentRelFramesPerSecond" * "$currentRelFrameBytesPerBone" * "$currentByte") + (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentAbsFramesPerSecond" * "$currentAbsFrameBytesPerBone" * "$currentByte"), \"currentPlayers\")"
# # solve(9600 = (("currentPlayers" * 4 * 30 * 2 * 8) + ("currentPlayers" * 4 * 3 * 33 * 8)), "currentPlayers") =
# # 1.1764706

# Group of ~8 players .
currentBitsPerSecond=115200 ; currentBonesPerPlayer=4 ; currentRelFramesPerSecond=60 ; currentRelFrameBytesPerBone=2 ; currentAbsFramesPerSecond=5 ; currentAbsFrameBytesPerBone=27 ; currentByte=8 ; solve "("$currentBitsPerSecond" == (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentRelFramesPerSecond" * "$currentRelFrameBytesPerBone" * "$currentByte") + (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentAbsFramesPerSecond" * "$currentAbsFrameBytesPerBone" * "$currentByte"), \"currentPlayers\")"
# # 14.117647

# 1Mbit/s
currentBitsPerSecond='(1 * megabit)' ; currentBonesPerPlayer=4 ; currentRelFramesPerSecond=60 ; currentRelFrameBytesPerBone=2 ; currentAbsFramesPerSecond=5 ; currentAbsFrameBytesPerBone=27 ; currentByte=8 ; _qalculate_nsolve "($currentBitsPerSecond == (x * $currentBonesPerPlayer * $currentRelFramesPerSecond * $currentRelFrameBytesPerBone * $currentByte) + (x * $currentBonesPerPlayer * $currentAbsFramesPerSecond * $currentAbsFrameBytesPerBone * $currentByte), x)"
# # 122.54902

# 10Gbit/s
currentBitsPerSecond='(10 * gigabit)' ; currentBonesPerPlayer=4 ; currentRelFramesPerSecond=60 ; currentRelFrameBytesPerBone=2 ; currentAbsFramesPerSecond=5 ; currentAbsFrameBytesPerBone=27 ; currentByte=8 ; _octave_nsolve "($currentBitsPerSecond == (x * $currentBonesPerPlayer * $currentRelFramesPerSecond * $currentRelFrameBytesPerBone * $currentByte) + (x * $currentBonesPerPlayer * $currentAbsFramesPerSecond * $currentAbsFrameBytesPerBone * $currentByte), x)"
# # 1225490.1960784313725490196078431

# 10Gbit/s (severely degraded and highly compressed)
currentBitsPerSecond='(10 * gigabit)' ; currentBonesPerPlayer=4 ; currentRelFramesPerSecond=15 ; currentRelFrameBytesPerBone=2 ; currentAbsFramesPerSecond=2 ; currentAbsFrameBytesPerBone=12 ; currentByte=8 ; _octave_nsolve "($currentBitsPerSecond == (x * $currentBonesPerPlayer * $currentRelFramesPerSecond * $currentRelFrameBytesPerBone * $currentByte) + (x * $currentBonesPerPlayer * $currentAbsFramesPerSecond * $currentAbsFrameBytesPerBone * $currentByte), x)"
# # 5787037.0370370370370370370370370

# 10Gbit/s (worst case expected to remain tolerable for any purpose)
currentBitsPerSecond='(10 * gigabit)' ; currentBonesPerPlayer=4 ; currentRelFramesPerSecond=5 ; currentRelFrameBytesPerBone=2 ; currentAbsFramesPerSecond=1 ; currentAbsFrameBytesPerBone=12 ; currentByte=8 ; _octave_nsolve "($currentBitsPerSecond == (x * $currentBonesPerPlayer * $currentRelFramesPerSecond * $currentRelFrameBytesPerBone * $currentByte) + (x * $currentBonesPerPlayer * $currentAbsFramesPerSecond * $currentAbsFrameBytesPerBone * $currentByte), x)"
# # 14204545.454545454545454545454545



# ### -Address Bytes per Axis-

# ### -Complete-

# 27 byte address (9^3)

currentLightYears=0.25 ; currentResolution=0.000025 ; _qalculate "0.18033688 * log(((9.454255*10^15) * "$currentLightYears") / "$currentResolution")"
# # 8.2946997

currentLightYears=2.00 ; currentResolution=0.000025 ; _qalculate "0.18033688 * log(((9.454255*10^15) * "$currentLightYears") / "$currentResolution")"
# # 8.6696997


# ### -Galactic-

# 20 byte address (7 * 2 + 6)

#5ly Milky Way - Usual 'Isolated' Star Separation
#0.05ly Suggested 'Synthetic/Compressed' Density
#~100x Per-Axis 'Compression'

#150ly Desired 'Irregular Bubble Galaxy' Size

#>25ly (5 stars) Thick
#~200ly (40 stars) Diameter
#8000 stars (5 * 40 * 40)

currentLightYears=0.25 ; currentResolution=10 ; _qalculate "0.18033688 * log(((9.454255*10^15) * "$currentLightYears") / "$currentResolution")"
# # 5.9684946

currentLightYears=2.00 ; currentResolution=10 ; _qalculate "0.18033688 * log(((9.454255*10^15) * "$currentLightYears") / "$currentResolution")"
# # 6.3434946


# ### -Instance-

# 12 byte address (4 * 3)

#100km
#25um resolution


#currentMeters=1500 ; currentResolution=0.0001 ; solve "( (2^(x*8))  == (  ( "$currentMeters" ) * 1/"$currentResolution"  ), x)"
# # Although very interesting at '2.9798074', the maximum distance of 1500meters is not at all acceptable.

currentMeters=100000 ; currentResolution=0.000025 ; solve "( (2^(x*8))  == (  ( "$currentMeters" ) * 1/"$currentResolution"  ), x)"
# # 3.9871691









# ### _Equations_

# ### -Address Bytes per Axis-

currentLightYears=10^5
currentResolution=0.0001

currentMeters=100000 ; currentResolution=0.000025 ; solve "( (2^(x*8))  == (  ( "$currentMeters" ) * 1/"$currentResolution"  ), x)"
# # 3.9871691

currentLightYears=10^5 ; currentResolution=0.0001 ; _qalculate "0.18033688 * log(((9.454255*10^15) * "$currentLightYears") / "$currentResolution")"
# # 10.370905



# ### -Bandwidth-

currentByte=8

currentBitsPerSecond=9600 ; currentBonesPerPlayer=4 ; currentRelFramesPerSecond=30 ; currentRelFrameBytesPerBone=2 ; currentAbsFramesPerSecond=3 ; currentAbsFrameBytesPerBone=33 ; currentByte=8 ; solve "("$currentBitsPerSecond" == (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentRelFramesPerSecond" * "$currentRelFrameBytesPerBone" * "$currentByte") + (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentAbsFramesPerSecond" * "$currentAbsFrameBytesPerBone" * "$currentByte"), \"currentPlayers\")"
# # solve(9600 = (("currentPlayers" * 4 * 30 * 2 * 8) + ("currentPlayers" * 4 * 3 * 33 * 8)), "currentPlayers") =
# # 1.8867925


# ### _Scratch_

# ### -Bandwidth-

currentByte=8

currentBitsPerSecond=9600
currentBonesPerPlayer=4
currentRelFramesPerSecond=30
currentRelFrameBytesPerBone=2
currentAbsFramesPerSecond=3
currentAbsFrameBytesPerBone=33



solve "("$currentBitsPerSecond" == (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentRelFramesPerSecond" * "$currentRelFrameBytesPerBone" * "$currentByte") + (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentAbsFramesPerSecond" * "$currentAbsFrameBytesPerBone" * "$currentByte"), \"currentPlayers\")"
# # solve(9600 = (("currentPlayers" * 4 * 30 * 2 * 8) + ("currentPlayers" * 4 * 3 * 33 * 8)), "currentPlayers") =
# # 1.8867925

_qalculate_nsolve "("$currentBitsPerSecond" == (x * "$currentBonesPerPlayer" * "$currentRelFramesPerSecond" * "$currentRelFrameBytesPerBone" * "$currentByte") + (x * "$currentBonesPerPlayer" * "$currentAbsFramesPerSecond" * "$currentAbsFrameBytesPerBone" * "$currentByte"), x)"
# # 1.8867925

_octave_nsolve "("$currentBitsPerSecond" == (x * "$currentBonesPerPlayer" * "$currentRelFramesPerSecond" * "$currentRelFrameBytesPerBone" * "$currentByte") + (x * "$currentBonesPerPlayer" * "$currentAbsFramesPerSecond" * "$currentAbsFrameBytesPerBone" * "$currentByte"), x)"
# # 1.8867924528301886792452830188679

solve(9600 == (x * 4 * 45 * 2 * 8) + (x * 4 * 2 * 33 * 8), x)



# ### -Address Bytes per Axis-

currentLightYears=10^5
currentResolution=0.0001

solve "( (2^(x*8))  == (  ( "$currentLightYears" * 9454254955488000 ) * 1/"$currentResolution"  ), x)"
# # 10.370905

solve '( (2^(x*8))  == (  ( "$currentLightYears" * 9454254955488000 ) * 1/"$currentResolution"  ), x)'
# # 0.18033688 * ln((9.454255E15 "$currentLightYears") / "$currentResolution")

_qalculate "0.18033688 * log(((9.454255*10^15) * "$currentLightYears") / "$currentResolution")"
# # 10.370905

_octave "0.18033688 * log(((9.454255*10^15) * "$currentLightYears") / "$currentResolution")"
# # 10.37090475046755







# ### _Reference_

#https://en.wikipedia.org/wiki/5G

#https://public.nrao.edu/ask/what-is-the-average-distance-between-stars-in-our-galaxy/

#https://en.wikipedia.org/wiki/M60-UCD1


