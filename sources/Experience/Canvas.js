import * as THREE from "three";
import Experience from "./Experience.js";

import vertex from "./Shader/canvas/vertex.glsl";
import fragment from "./Shader/canvas/fragment.glsl";

export default class Canvas {
  constructor() {
    this.experience = new Experience();
    this.scene = this.experience.scene;
    this.config = this.experience.config;
    this.time = this.experience.time;
    this.mouse = this.experience.mouse.instance;

    this.setGeometry();
    this.setMaterial();
    this.setMesh();
  }

  setGeometry() {
    this.geometry = new THREE.PlaneGeometry(2, 2, 1, 1);
  }

  setMaterial() {
    this.material = new THREE.ShaderMaterial({
      vertexShader: vertex,
      fragmentShader: fragment,
      uniforms: {
        u_mouse: { value: new THREE.Vector2() },
        u_resolution: { value: new THREE.Vector2() },
        u_time: { value: 0 },
      }
    });
  }

  setMesh() {
    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.scene.add(this.mesh);
  }

  update() {
    // mouse position
    this.material.uniforms.u_mouse.value.x = this.mouse.x;
    this.material.uniforms.u_mouse.value.y = this.mouse.y;

    // resolution
    this.material.uniforms.u_resolution.value.x = this.config.width;
    this.material.uniforms.u_resolution.value.y = this.config.height;

    // time
    this.material.uniforms.u_time.value += this.time.delta * 0.0005;
  }
}
