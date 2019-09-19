#!/usr/bin/env python
'''
Ian Rambo 2017
Calculate NX and basic stats for a FASTA file, e.g. assembled contigs.
'''
import argparse
#==============================================================================
def calc_nx(fasta, nx, gt) :
	'''
	Calculate NX statistic for a FASTA file.
	'''
	#NX value to calculate. E.g. N50 is 0.50
	nx = float(nx)
	gt = int(gt)
	seqLens = []
	with open(fasta, 'r') as fa :
		seq = False
		for f in fa :
			f = f.rstrip()
			if f.startswith('>') :
				seq = False
				pass
			else :
				seq = True
				slen = float(len(f))
				seqLens.append(slen)

	assemblySize = float(sum(seqLens))
	#NX value
	NX = float()
	lsum = 0
	stats = {} #Dictionary of assembly stats
	seqLens = sorted(seqLens, reverse = True)
	seqMax = max(seqLens)
	seqMin = min(seqLens)

	for i in range(len(seqLens)) :
		lsum += seqLens[i]
		if lsum >= assemblySize*nx :
			NX = seqLens[i]
			break

	stats['nx'] = NX
	stats['seqMax'] = seqMax
	stats['seqMin'] = seqMin
	stats['seqMean'] = int(assemblySize)/len(seqLens)
	stats['nSeq'] = len(seqLens)
	stats['assSize'] = assemblySize #size of dat assembly
	stats['gNX'] = len([s for s in seqLens if s >= NX])
	stats['gGT'] = len([s for s in seqLens if s >= gt])
	return(stats)
#==============================================================================
nxopts = nxparser.parse_args()
stats = calc_nx(nxopts.fasta, nxopts.nx, nxopts.gt)
nxparser = argparse.ArgumentParser()
nxparser.add_argument('--fasta', type=str, dest='fasta', action='store', help='input FASTA file')
nxparser.add_argument('--nx', type=float, dest='nx', action='store', help='NX stat to calculate; e.g. N50 is 0.50')
nxparser.add_argument('--gt', type=int, dest='gt', action='store', help='determine number of sequences >= a length')
print(stats)

# print("""\nFile: %s\nTotal assembly size: %d\nnSequences: %d\nN%d value: %.0f\nmax \
# 	length: %d\nmin length: %d\nmean length: %d\nsequences >= N%d: \
# 	%d\nsequences >= %dbp: %d % (nxopts.fasta,stats['assSize'],stats['nSeq'],nxopts.nx*100,stats['nx'],stats['seqMax'],stats['seqMin'],stats['seqMean'],nxopts.nx*100,stats['gNX'],greaterThan, stats['gGT'])""")
#
# exit()
