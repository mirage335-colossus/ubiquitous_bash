
Software equivalents of a 'shared pair of wires' are very roughly considered here. A service that can accept an unlimited number of new input pipes at any time, and combine all these inputs to be sent to new output pipes at any time to be used by an unlimited number of programs.

Hardware bus may be as simple as a shared pair of wires with clients responsible for collision detection. Software bus implementations rarely seem to achieve such simplicity. Much missed potential seems to exist for reliability, interactivity, and compatibility. Especially, interacting with an InterProcess-Communication (IPC) bus usually seems more complex or less standardized, than a hardware bus connected to a terminal emulator .

As an example, a program should be able to create new program instances (eg. Klipper 3D printer firmware running in a Virtual Machine, simulated motors, etc) with unique names and emulated serial ports connected to this bus, thereafter being able to learn whether bootup was successful, what IP address had been assigned, and, possibly across another emulated serial port connected to a separate bus, communicate further (possibly interactive user-input to diagnose 3D printer firmware behavior).

-


Threads share variables. Some kind of lock may be required to manage this safely. Minimalist portable libraries apparently exist for such purposes. Both UNIX and MSW have roughly equivalent calls to create threads.

Processes can only share pipes, named pipe files, or shared memory files. Both UNIX and MSW have roughly equivalent calls to open files as shared memory.

Pipes are inherently single-input single-output due to the arguably single-threaded nature of memory access by computer automation. A compiled program equivalent to 'tee' would need to check for alternate output FIFO pipe files in a specified directory, and begin writing data. Theoretically, it may be feasible to implement this as a shell script, in practice, performance from reading/writing byte-by-byte in this manner is likely to be marginal even for the least demanding use cases. A shell script - or even a compiled program - might also not properly tolerate closure of a write pipe without itself closing. Extensive research strongly suggests no existing widely deployed precompiled software provides the resources necessary to add new input/output pipe files without closing the existing pipes.

TCP listen servers implemented by SOCAT may receive traffic from many sources, and combine that traffic into a single stream. However, there is apparently no way to 'cast' any stream to all connected clients - bytes or lines are sent to apparently randomly chosen clients. Thus, a TCP listen server could aggregate input messages to be processed by a single program, but not to distribute replies. Unusable, given the need for confirmation with such networks. However, TCP listen servers which do not fork, but instead pipe individual processes in/out ofrandomly named FIFOs, could extend a 'pipe aggregator' to TCP. Such an architecture would stil have the problem of closing existing pipes, unless a suitable compiled program equivalent to 'tee' without that limitation was available.

Message queues (eg. 'ZeroMQ') apparently are motivated partly by these limitations, however, the more useful implementations of these seem to be intended as libraries for compiled programs. Additionally, the most convenient 'ipc' transport provided by 'ZeroMQ' is not natively supported for the MSW platform.

Pure triple buffer filesystem aggregators may be less performant and efficient, however, they do have the advantage of not requiring compiled binary programs (which may reduce portability) or subprocess management (which may be improperly influenced). Such buffers can be checked for new inputs, or existing inputs with new 'tick' file increments, and the output written to a single triple buffer file set after receiving a reasonable amount of data or waiting a reasonable time. Any program - indeed a shell script - may then read the resulting file set continiously into a pipe. Typical UNIX systems can easily process this in RAM using '/dev/shm' . For other platforms, at a rate of 100kB/s, 8.64GB/day, 3.1536TB/year of wear might accumulate on a SSD, equating to 1% of a typical 128GB-4TB SSD TBW rating. A 100year lifespan limitation on MSW SSD systems should be an entirely reasonable fallback expenditure if UNIX cannot be used and if the relevant use cases do not attract sufficient developer resources to maintain sufficiently reliable compiled programs that are able to call on MSW shared memory.

Ports, if TCP/UDP is used, are to be 6391 and alternatively 24671 . An IPC service that may be used on a one-per-machine basis may need such  static allocation for software simplicity. Subsequent ports (eg. 6392, 24672) may be used for UI (eg. VR Compositor) specific message bus, for which reliability is essential, or (eg. 6393, 24673) for non-essential developer/diagnostic message service (which may be frequently interrupted interactively), or (eg. 6394, 24674) for messages that may ultimately be intended for remote network destinations. Services similar to InterProcess-Communication seem to be assigned numbers near these regions, with somewhat large quantities of apparently unused adjacent port numbers, and larger quantities of apparently rarely used adjacent port numbers.


# Scratch - triple buffer

```
# Beware forking (ie. use of "$scriptAbsoluteLocation" ) must be avoided within triple buffer loops - unacceptable delays may occur .

while true
do
	# find all files (eg. 'uid-tick') - delay while no new buffers/directives
	
	# loop through all valid input files
		# loop through all incremented tick valid input files
			# cat append new buffers to output buffer
	
	# increment output buffer tick
	
	# delay minimum of 3s - both to minimize processor load and ensure recipients will not be overloaded with updates
done
```

# Scratch - adapter - pipe TO triple buffer (or vice versa)

```
while true
do
	# wait for new tick (or vice versa do not)
	
	# cat buffer to 'stdout' (or vice versa from 'stdin')
	
	# (or vice versa write new tick)
		# possibly delay 1s
done
```


# Scratch - aggregator

```
while true
do
	# find all files (eg. 'fifo-uid-input') - delay while no new pipes/directives and no change in daemon PIDs being active
		# terminate/linger - any kind of '_stop' should write 'terminate' , delete 'linger' , remove temporary directory , in that order
	
	# terminate old daemons ( including diverter PID )
	
	# daemonize 'cat' process(es) to join all input pipes
	
	# daemonize 'cat' or similar process(es) to forward to all output pipes
	
	
	# if 'nodivert' file present OR if 'diverter' file not present with active PID (active being determined within context of parent process)
	#then
		# daemonize 'cat' or similar process(es) to forward from input to output process
	
	
	# Monitor/throttle broadcastPipe. If at 100%, write 'full' file flag for diagnostic use.
	
done
```


# Scratch - socat

```
socat -4 - TCP-LISTEN:1237,fork
socat - tcp:localhost:1237
```



# Reference

https://en.wikipedia.org/wiki/POSIX_Threads
https://www.tutorialspoint.com/windows-thread-api-in-the-c-program

https://github.com/mirage335/BiosignalProcessor/blob/master/src/BiosignalProcessor.c#L147
https://en.wikipedia.org/wiki/Shared_memory


http://compgroups.net/comp.linux.development.system/-dev-fanout-a-one-to-many-multi/2869739
	Fanout is a module that replicates its input out to all processes reading from it.
	...
	That is better to do in userspace using sockets or pipes.
	...
	A pipe can only have one useful reader.
	...
	That reader can be tee(1).
	...
	That's rather static. Once you start things up you can't
	add a reader. What if one wanted to attach another reader
	a week after the writer was started?
	...
	Write an extended tee(1) which you can talk to and reconfigure on the
	fly (over an AF_UNIX socket. say). There's still no need for nor
	advantage in doing this in-kernel.


https://hackaday.io/project/279-sonomkr-noise-monitoring/log/86364-zeromq-vs-dbus-for-pub-sub-pattern
	Booom ! I was publishing messages on a tcp port.

https://www.ontrack.com/en-us/blog/how-long-do-ssds-really-last
	Samsung states that their Samsung SSD 850 PRO SATA, with a capacity of 128 GB, 256 GB, 512 or 1 TB,  is "built to handle 150 terabytes written (TBW), which equates to a 40 GB daily read/write workload over a ten-year period."  Samsung even promises that the product is "withstanding up to 600 terabytes written (TBW)."


https://svn.nmap.org/nmap/nmap-services
	6391...
		unknown	6395/udp	0.000661
		crystalenterprise	6401/tcp	0.000050	# Seagate Crystal Enterprise | boe-was
		boe-was	6401/udp	0.000000
	24671...
		canditv	24676/tcp	0.000000	# Canditv Message Service
		flashfiler	24677/tcp	0.000000
		flashfiler	24677/udp	0.000654	# FlashFiler
		proactivate	24678/tcp	0.000000	# Turbopower Proactivate
		proactivate	24678/udp	0.000000	# Turbopower Proactivate
		unknown	24679/udp	0.000654







https://en.wikipedia.org/wiki/Multi-master_bus
https://en.wikipedia.org/wiki/I%C2%B2C
https://electronics.stackexchange.com/questions/199256/i2c-multiple-master-collision



