import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api';
import { ChangeDetectorRef } from '@angular/core';

@Component({
  selector: 'app-reportes',
  standalone: true,
  imports: [
    CommonModule
  ],
  templateUrl: './reportes.html',
  styleUrl: './reportes.scss'
})
export class ReportesComponent implements OnInit {

  clientes:any[] = [];
  proyectos:any[] = [];
  materiales:any[] = [];

  constructor(
  private api: ApiService,
  private cd: ChangeDetectorRef
){}

  ngOnInit(): void {

    this.cargarClientes();
    this.cargarProyectos();
    this.cargarMateriales();

  }

  cargarClientes(){

    this.api.obtenerClientes()
    .subscribe((resp:any)=>{

      this.clientes = resp.clientes || resp;
      this.cd.detectChanges();
    });

  }

  cargarProyectos(){

    this.api.obtenerProyectos()
    .subscribe((resp:any)=>{

      this.proyectos = resp.proyectos || resp;
      this.cd.detectChanges();
    });

  }

  cargarMateriales(){

    this.api.obtenerMateriales()
    .subscribe((resp:any)=>{

      this.materiales = resp.materiales || resp;
      this.cd.detectChanges();
    });

  }

}