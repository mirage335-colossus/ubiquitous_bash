
# Demonstrates low bandwidth (9600bits), high framerate (60Hz), high resolution (0.25um), galactic scale (2.00ly diameter 8000 stars), high player count (>>122 players) netcode is simultaneously achievable.

# 27byte 'Complete' 2.00ly Diameter 0.25um Resolution Address
# 20byte 'Galactic' 2.00ly Diameter 10m Resolution Address
# 12byte 'Instance' 100km Diameter 0.25um Resolution Address



# Suggested parameters for experimental netcode.

currentInstantFramesPerSecond=5
currentIncrementFramesPerSecond=60
currentInstantFrameBytesPerBone=27
currentIncrementFrameBytesPerBone=2

# Theoretically, >5 million players could share a single 10Gbits server/WiFi6 connection for real-time VR multiplayer.





# Part of 'Ubiquitous Bash' . All equations are expected to run within a 'bash' shell having imported 'Ubiquitous Bash' functions through '_setupUbiquitous' or similar. Both 'qalculate' and 'octave' may be used as backends as appropriate.



# ### _Estimates_


# ### -Bandwidth-

currentByte=8


# Severely degraded and highly compressed connection between just two players.
currentBitsPerSecond=9600 ; currentBonesPerPlayer=4 ; currentIncrementFramesPerSecond=15 ; currentIncrementFrameBytesPerBone=2 ; currentInstantFramesPerSecond=2 ; currentInstantFrameBytesPerBone=12 ; currentByte=8 ; solve "("$currentBitsPerSecond" == (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentIncrementFramesPerSecond" * "$currentIncrementFrameBytesPerBone" * "$currentByte") + (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentInstantFramesPerSecond" * "$currentInstantFrameBytesPerBone" * "$currentByte"), \"currentPlayers\")"
# # solve(9600 = (("currentPlayers" * 4 * 30 * 2 * 8) + ("currentPlayers" * 4 * 3 * 33 * 8)), "currentPlayers") =
# # 5.5555556

currentBitsPerSecond=9600 ; currentBonesPerPlayer=4 ; currentIncrementFramesPerSecond=60 ; currentIncrementFrameBytesPerBone=2 ; currentInstantFramesPerSecond=5 ; currentInstantFrameBytesPerBone=27 ; currentByte=8 ; solve "("$currentBitsPerSecond" == (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentIncrementFramesPerSecond" * "$currentIncrementFrameBytesPerBone" * "$currentByte") + (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentInstantFramesPerSecond" * "$currentInstantFrameBytesPerBone" * "$currentByte"), \"currentPlayers\")"
# # solve(9600 = (("currentPlayers" * 4 * 30 * 2 * 8) + ("currentPlayers" * 4 * 3 * 33 * 8)), "currentPlayers") =
# # 1.1764706

# Group of ~8 players .
currentBitsPerSecond=115200 ; currentBonesPerPlayer=4 ; currentIncrementFramesPerSecond=60 ; currentIncrementFrameBytesPerBone=2 ; currentInstantFramesPerSecond=5 ; currentInstantFrameBytesPerBone=27 ; currentByte=8 ; solve "("$currentBitsPerSecond" == (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentIncrementFramesPerSecond" * "$currentIncrementFrameBytesPerBone" * "$currentByte") + (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentInstantFramesPerSecond" * "$currentInstantFrameBytesPerBone" * "$currentByte"), \"currentPlayers\")"
# # 14.117647

# 1Mbit/s
currentBitsPerSecond='(1 * megabit / bit)' ; currentBonesPerPlayer=4 ; currentIncrementFramesPerSecond=60 ; currentIncrementFrameBytesPerBone=2 ; currentInstantFramesPerSecond=5 ; currentInstantFrameBytesPerBone=27 ; currentByte=8 ; _qalculate_nsolve "($currentBitsPerSecond == (x * $currentBonesPerPlayer * $currentIncrementFramesPerSecond * $currentIncrementFrameBytesPerBone * $currentByte) + (x * $currentBonesPerPlayer * $currentInstantFramesPerSecond * $currentInstantFrameBytesPerBone * $currentByte), x)"
# # 122.54902

# 10Gbit/s
currentBitsPerSecond='(10 * gigabit / bit)' ; currentBonesPerPlayer=4 ; currentIncrementFramesPerSecond=60 ; currentIncrementFrameBytesPerBone=2 ; currentInstantFramesPerSecond=5 ; currentInstantFrameBytesPerBone=27 ; currentByte=8 ; _octave_nsolve "($currentBitsPerSecond == (x * $currentBonesPerPlayer * $currentIncrementFramesPerSecond * $currentIncrementFrameBytesPerBone * $currentByte) + (x * $currentBonesPerPlayer * $currentInstantFramesPerSecond * $currentInstantFrameBytesPerBone * $currentByte), x)"
# # 1225490.1960784313725490196078431

# 10Gbit/s (severely degraded and highly compressed)
currentBitsPerSecond='(10 * gigabit / bit)' ; currentBonesPerPlayer=4 ; currentIncrementFramesPerSecond=15 ; currentIncrementFrameBytesPerBone=2 ; currentInstantFramesPerSecond=2 ; currentInstantFrameBytesPerBone=12 ; currentByte=8 ; _octave_nsolve "($currentBitsPerSecond == (x * $currentBonesPerPlayer * $currentIncrementFramesPerSecond * $currentIncrementFrameBytesPerBone * $currentByte) + (x * $currentBonesPerPlayer * $currentInstantFramesPerSecond * $currentInstantFrameBytesPerBone * $currentByte), x)"
# # 5787037.0370370370370370370370370

# 10Gbit/s (worst case expected to remain tolerable for any purpose)
currentBitsPerSecond='(10 * gigabit / bit)' ; currentBonesPerPlayer=4 ; currentIncrementFramesPerSecond=5 ; currentIncrementFrameBytesPerBone=2 ; currentInstantFramesPerSecond=1 ; currentInstantFrameBytesPerBone=12 ; currentByte=8 ; _octave_nsolve "($currentBitsPerSecond == (x * $currentBonesPerPlayer * $currentIncrementFramesPerSecond * $currentIncrementFrameBytesPerBone * $currentByte) + (x * $currentBonesPerPlayer * $currentInstantFramesPerSecond * $currentInstantFrameBytesPerBone * $currentByte), x)"
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

currentBitsPerSecond=9600 ; currentBonesPerPlayer=4 ; currentIncrementFramesPerSecond=30 ; currentIncrementFrameBytesPerBone=2 ; currentInstantFramesPerSecond=3 ; currentInstantFrameBytesPerBone=33 ; currentByte=8 ; solve "("$currentBitsPerSecond" == (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentIncrementFramesPerSecond" * "$currentIncrementFrameBytesPerBone" * "$currentByte") + (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentInstantFramesPerSecond" * "$currentInstantFrameBytesPerBone" * "$currentByte"), \"currentPlayers\")"
# # solve(9600 = (("currentPlayers" * 4 * 30 * 2 * 8) + ("currentPlayers" * 4 * 3 * 33 * 8)), "currentPlayers") =
# # 1.8867925


# ### _Scratch_

# ### -Bandwidth-

currentByte=8

currentBitsPerSecond=9600
currentBonesPerPlayer=4
currentIncrementFramesPerSecond=30
currentIncrementFrameBytesPerBone=2
currentInstantFramesPerSecond=3
currentInstantFrameBytesPerBone=33



solve "("$currentBitsPerSecond" == (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentIncrementFramesPerSecond" * "$currentIncrementFrameBytesPerBone" * "$currentByte") + (\"currentPlayers\" * "$currentBonesPerPlayer" * "$currentInstantFramesPerSecond" * "$currentInstantFrameBytesPerBone" * "$currentByte"), \"currentPlayers\")"
# # solve(9600 = (("currentPlayers" * 4 * 30 * 2 * 8) + ("currentPlayers" * 4 * 3 * 33 * 8)), "currentPlayers") =
# # 1.8867925

_qalculate_nsolve "("$currentBitsPerSecond" == (x * "$currentBonesPerPlayer" * "$currentIncrementFramesPerSecond" * "$currentIncrementFrameBytesPerBone" * "$currentByte") + (x * "$currentBonesPerPlayer" * "$currentInstantFramesPerSecond" * "$currentInstantFrameBytesPerBone" * "$currentByte"), x)"
# # 1.8867925

_octave_nsolve "("$currentBitsPerSecond" == (x * "$currentBonesPerPlayer" * "$currentIncrementFramesPerSecond" * "$currentIncrementFrameBytesPerBone" * "$currentByte") + (x * "$currentBonesPerPlayer" * "$currentInstantFramesPerSecond" * "$currentInstantFrameBytesPerBone" * "$currentByte"), x)"
# # 1.8867924528301886792452830188679

solve '(9600 == (x * 4 * 45 * 2 * 8) + (x * 4 * 2 * 33 * 8), x)'
# # 1.9230769



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



#https://github.com/MFatihMAR/Game-Networking-Resources

#https://github.com/networkprotocol/netcode
#https://github.com/GlaireDaggers/Unity-Netcode.IO
#https://github.com/RedpointGames/netcode.io-UE4


#https://github.com/networkprotocol/yojimbo


#http://www.nafonso.com/home/unreal-framework-network
#https://developer.oculus.com/blog/networked-physics-in-virtual-reality-networking-a-stack-of-cubes-with-unity-and-physx/






# ### _Vector_

return 0
exit 1


clear ; . ./README.sh

5.5555556
1.1764706
14.117647
122.54902
1225490.1960784313725490196078431
5787037.0370370370370370370370370
14204545.454545454545454545454545
8.2946997
8.6696997
5.9684946
6.3434946
3.9871691
3.9871691
10.370905
1.8867925
1.8867925
1.8867925
1.8867924528301886792452830188679
1.9230769
10.370905
0.18033688 * ln((9.454255E15 "$currentLightYears") / "$currentResolution")
10.370905
10.37090475046755





