shader_type canvas_item;

uniform vec2 topleft;
uniform vec2 topright;
uniform vec2 bottomleft;
uniform vec2 bottomright;


float mycross( in vec2 a, in vec2 b ) { return a.x*b.y - a.y*b.x; }

vec2 invBilinear( in vec2 p, in vec2 a, in vec2 b, in vec2 c, in vec2 d )
{
   vec2 res = vec2(-1.0);

    vec2 e = b-a;
    vec2 f = d-a;
    vec2 g = a-b+c-d;
    vec2 h = p-a;
        
    float k2 = mycross( g, f );
    float k1 = mycross( e, f ) + mycross( h, g );
    float k0 = mycross( h, e );
    
    // if edges are parallel, this is a linear equation. Do not this test here though, do
    // it in the user code
    if( abs(k2)<0.001 )
    {
        float v = -k0/k1;
        float u  = (h.x*k1+f.x*k0) / (e.x*k1-g.x*k0);
        if( v>0.0 && v<1.0 && u>0.0 && u<1.0 )  res = vec2( u, v );
    }
	else
    {
        // otherwise, it's a quadratic
        float w = k1*k1 - 4.0*k0*k2;
        if( w<0.0 ) return vec2(-1.0);
        w = sqrt( w );

        float ik2 = 0.5/k2;
        float v = (-k1 - w)*ik2; if( v<0.0 || v>1.0 ) v = (-k1 + w)*ik2;
        float u = (h.x - f.x*v)/(e.x + g.x*v);
        if( u<0.0 || u>1.0 || v<0.0 || v>1.0 ) return vec2(-1.0);
        res = vec2( u, v );
    }
    
    return res;
}



void fragment(){
	vec2 topleftUV = topleft /vec2(textureSize(TEXTURE,0));
	vec2 toprightUV = vec2(1.0,0.0)+topright /vec2(textureSize(TEXTURE,0));
	vec2 bottomrightUV = vec2(1.0,1.0)+bottomright /vec2(textureSize(TEXTURE,0));
	vec2 bottomleftUV =vec2(0.0,1.0)+ bottomleft /vec2(textureSize(TEXTURE,0));
	vec2 newUV = invBilinear(UV,topleftUV,toprightUV,bottomrightUV,bottomleftUV);
	
	if (topleft.x==0.0&& topright.x== 0.0) {
		COLOR = texture(TEXTURE,UV);
	}else{
	if (newUV == vec2(-1.0,-1.0)){
		COLOR = vec4(0.0,0.0,0.0,0.0);
	}else{
		COLOR = texture(TEXTURE,newUV);
	}
	}
	

		
}
//void vertex(){
//if( UV.x <= 0.0 && UV.y <= 0.0) {
//VERTEX+=topleft
//}
//if( UV.x >= 1.0 && UV.y <= 0.0) {
//VERTEX+=topright
//}
//if( UV.x <= 0.0 && UV.y >= 1.0) {
//VERTEX+=bottomleft
//}
//if( UV.x >= 1.0 && UV.y >= 1.0) {
//VERTEX+=bottomright
//}
//
//}