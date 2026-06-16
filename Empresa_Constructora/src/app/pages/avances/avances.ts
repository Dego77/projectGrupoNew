import {
  Component,
  OnInit,
  ChangeDetectorRef
} from '@angular/core';

import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { ApiService } from '../../services/api';

@Component({
  selector: 'app-avances',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './avances.html',
  styleUrl: './avances.scss'
})
export class AvancesComponent implements OnInit {

  proyectos: any[] = [];
  avances: any[] = [];

  avance = {
    id_proyecto: '',
    titulo: '',
    descripcion: '',
    responsable: '',
    porcentaje_avance: 0
  };

  constructor(
    private api: ApiService,
    private cd: ChangeDetectorRef
  ){}

  ngOnInit(): void {

    this.cargarProyectos();
    this.cargarAvances();

  }

  cargarProyectos(){

    this.api.obtenerProyectos()
      .subscribe({

        next: (resp:any) => {

          console.log('PROYECTOS:', resp);

          this.proyectos = [...resp];

          this.cd.detectChanges();

        },

        error: (err) => {

          console.error(err);

        }

      });

  }

  cargarAvances(){

    this.api.obtenerAvances()
      .subscribe({

        next: (resp:any) => {

          console.log('AVANCES:', resp);

          this.avances = [...resp];

          this.cd.detectChanges();

        },

        error: (err) => {

          console.error('ERROR AVANCES:', err);

        }

      });

  }

  registrarAvance(){

    this.api.crearAvance(this.avance)
      .subscribe({

        next: () => {

          alert('Avance registrado');

          this.avance = {
            id_proyecto: '',
            titulo: '',
            descripcion: '',
            responsable: '',
            porcentaje_avance: 0
          };

          this.cargarAvances();

        },

        error: (err) => {

          console.error(err);

        }

      });

  }

}