import {
  Component,
  OnInit,
  ChangeDetectorRef
} from '@angular/core';

import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-inventario',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './inventario.html',
  styleUrls: ['./inventario.scss']
})
export class InventarioComponent implements OnInit {

  materiales: any[] = [];
  materialesFiltrados: any[] = [];

  filtro = '';

  stockCritico = 0;
  stockBajo = 0;

  constructor(
    private api: ApiService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {

    this.cargarMateriales();

  }

  cargarMateriales(): void {

    this.api.obtenerMateriales()
      .subscribe({

        next: (resp: any) => {

          console.log('RESPUESTA MATERIAL:', resp);

          this.materiales = resp || [];

          this.materialesFiltrados = [...this.materiales];

          this.stockCritico =
            this.materiales.filter(m => m.stock <= 2).length;

          this.stockBajo =
            this.materiales.filter(
              m => m.stock > 2 && m.stock <= 5
            ).length;

          this.cdr.detectChanges();

        },

        error: (err) => {

          console.error('ERROR MATERIALES', err);

        }

      });

  }

  filtrarMateriales(): void {

    this.materialesFiltrados =
      this.materiales.filter(material =>
        material.nombre
          .toLowerCase()
          .includes(this.filtro.toLowerCase())
      );

  }

  obtenerEstado(stock: number): string {

    if (stock <= 2) {
      return 'Crítico';
    }

    if (stock <= 5) {
      return 'Bajo';
    }

    return 'Normal';

  }

}