import * as THREE from 'three'
import Experience from '../Experience.js'

export default class World
{
    constructor(_options)
    {
        this.experience = new Experience()
        this.config = this.experience.config
        this.scene = this.experience.scene
        this.instance = new THREE.Vector2()

        this.setMouseEvents()
    }

    setMouseEvents() {
      this.listener = window.addEventListener('mousemove', (_event) =>
      {
          // normalized mouse position -0.5 to 0.5
          this.instance.x = (_event.clientX / this.config.width)
          this.instance.y = (_event.clientY / this.config.height)
      })
    }

    update() {

    }

    destroy() {
      if(this.listener) {
        window.removeEventListener('mousemove', this.listener)
      }
    }
}