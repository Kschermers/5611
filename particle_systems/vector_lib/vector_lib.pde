class KVector {
  float x;
  float y;
  float z;
  
  KVector() {
    x = 0;
    y = 0;
    z = 0;
  }
  
  KVector(KVector that) {
    this.x = that.x;
    this.y = that.y;
    this.z = that.z;
  }
  
  void add(KVector that) {
    this.x += that.x;
    this.y += that.y;
    this.z += that.z;
  }
  
  void subtract(KVector that) {
    this.x -= that.x;
    this.y -= that.y;
    this.z -= that.z;
  }
  
  void scalar(float k) {
    this.x *= k;
    this.y *= k;
    this.z *= k;
  }
  
  float mag() {
    return sqrt(x * x + y * y + z * z);
  }
  
  float dot(KVector that) {
    return this.x * that.x + this.y * that.y + this.z * that.z;
  }
  
  float angleBetween(KVector that) {
    return acos(this.dot(that) / (this.mag() * that.mag());
  }
  
  KVector cross(KVector that) {
  }
   return new KVector(this.y * that.z - this.z * that.y, this.z * that.x - this.x * that.z, this.x * that.y - this.y * that.x);
}
    
    
    
   
