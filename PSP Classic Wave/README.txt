README.txt

In URP, multipass shaders aren't supported (they DO work in the UI tho.)
If you need to use this in URP (or you only want the wave as an overlay), extract the URP unitypackage. Inside you'll find two shaders, one with the vertical color gradient and the second with the wave overlay alone (both work in both BIRP and URP [HDRP not tested]).
The 'workaround' for URP is to use multiple materials over the same mesh, there's an example included in the URP package.

Feel free to delete the packages that you don't need, the only required file is 'PSPClassicWave.hlsl' and your .shader(s) of choice.