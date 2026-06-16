import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ChangeDetectorRef } from '@angular/core';

import { ApiService } from '../../services/api';

@Component({
  selector: 'app-rrhh',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './rrhh.html',
  styleUrl: './rrhh.scss'
})
export class RrhhComponent implements OnInit {

  empleado = {
    nombre: '',
    cargo: '',
    salario: '',
    telefono: ''
  };

  empleados:any[] = [];

  constructor(
  private api: ApiService,
  private cd: ChangeDetectorRef
){}

  ngOnInit(): void {

    this.cargarEmpleados();

  }

  cargarEmpleados(){

    this.api.obtenerEmpleados()
    .subscribe({

      next: (resp:any) => {

  console.log(resp);

  this.empleados = resp.empleados || resp;

  this.cd.detectChanges();

},

      error: (err) => {

        console.log(err);

      }

    });

  }

  registrarEmpleado(){

    this.api.crearEmpleado(this.empleado)
    .subscribe({

      next: () => {

        alert('Empleado registrado');

        this.empleado = {
          nombre: '',
          cargo: '',
          salario: '',
          telefono: ''
        };

        this.cargarEmpleados();

      },

      error: (err) => {

        console.log(err);

        alert('Error al registrar');

      }

    });

  }

  eliminarEmpleado(id:number){

    if(!confirm('¿Eliminar empleado?')) return;

    this.api.eliminarEmpleado(id)
    .subscribe({

      next: () => {

        alert('Empleado eliminado');

        this.cargarEmpleados();

      },

      error: (err) => {

        console.log(err);

        alert('Error al eliminar');

      }

    });

  }

  editarEmpleado(emp:any){

    this.empleado = {

      nombre: emp.nombre,
      cargo: emp.cargo,
      salario: emp.salario,
      telefono: emp.telefono

    };

  }

}