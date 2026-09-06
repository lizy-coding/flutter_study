#!/usr/bin/env python3
import subprocess,sys,os
compiler=os.environ.get('FORGE_REAL_CLANG') or subprocess.check_output(
 ['xcrun', '--find', 'clang'], text=True).strip()
args=sys.argv[1:]
if all(x in args for x in ['-v','-E','-dM']) and args[-1]=='/dev/null':
 r=subprocess.run([compiler,*args],capture_output=True)
 # Drop only clang's verbose cc1 command echo; retain version, macros, diagnostics.
 err=r.stderr if r.returncode else b'\n'.join(x for x in r.stderr.split(b'\n') if b'" -cc1 ' not in x)
 sys.stdout.buffer.write(r.stdout)
 sys.stderr.buffer.write(err)
 sys.exit(r.returncode)
os.execv(compiler,[compiler,*args])
