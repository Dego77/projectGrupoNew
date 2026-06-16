import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-compras',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './compras.html',
  styleUrl: './compras.scss'
})
export class ComprasComponent implements OnInit {

  proveedor = {
    nombre: '',
    contacto: ''
  };

  compra = {
    id_proveedor: '',
    fecha: '',
    total: 0
  };

  detalle = {
    id_compra: '',
    id_material: '',
    cantidad: 0,
    precio: 0
  };
  material = {
  nombre: '',
  precio: 0,
  stock: 0
};

  proveedores: any[] = [];
  compras: any[] = [];
  materiales: any[] = [];

  constructor(private api: ApiService){}

  ngOnInit(): void {

    this.cargarProveedores();
    this.cargarCompras();
    this.cargarMateriales();

  }

  cargarProveedores(){

    this.api.obtenerProveedores()
    .subscribe((resp:any)=>{

      this.proveedores = resp;

    });

  }

  cargarCompras(){

    this.api.obtenerCompras()
    .subscribe((resp:any)=>{

      this.compras = resp;

    });

  }

  cargarMateriales(){

    this.api.obtenerMateriales()
    .subscribe((resp:any)=>{

      this.materiales = resp;

    });

  }

  registrarProveedor(){

    this.api.crearProveedor(this.proveedor)
    .subscribe(()=>{

      alert('Proveedor registrado');

      this.cargarProveedores();

    });

  }

  registrarCompra(){

    this.api.crearCompra(this.compra)
    .subscribe(()=>{

      alert('Compra registrada');

      this.cargarCompras();

    });

  }

  registrarDetalleCompra(){

    this.api.crearDetalleCompra(this.detalle)
    .subscribe(()=>{

      alert('Detalle registrado');

    });

  }
  registrarMaterial(){

  this.api.crearMaterial(this.material)
  .subscribe(()=>{

    alert('Material registrado');

    this.material = {
      nombre: '',
      precio: 0,
      stock: 0
    };

    this.cargarMateriales();

  });

}
  

}