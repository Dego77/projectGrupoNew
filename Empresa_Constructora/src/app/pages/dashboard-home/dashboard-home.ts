import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';

import { BaseChartDirective } from 'ng2-charts';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-dashboard-home',
  standalone: true,
  imports: [
    CommonModule,
    BaseChartDirective
  ],
  templateUrl: './dashboard-home.html',
  styleUrl: './dashboard-home.scss'
})
export class DashboardHomeComponent implements OnInit {

  cantClientes = 0;
  cantObras = 0;
  totalVentas = 0;
  cantAlertas = 0;

  lineChartData: any = {
    labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'],
    datasets: [
      {
        data: [0, 0, 0, 0, 0, 0],
        label: 'Ventas',
        tension: 0.4
      }
    ]
  };

  lineChartType: any = 'line';

  pieChartData: any = {
    labels: [
      'En construcción',
      'Planificación',
      'Finalizados'
    ],
    datasets: [
      {
        data: [0, 0, 0]
      }
    ]
  };

  pieChartType: any = 'pie';

  constructor(
    private apiService: ApiService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit() {
    this.cargarMetricas();
  }

  cargarMetricas() {
    // Clientes
    this.apiService.obtenerClientes().subscribe({
      next: (res: any[]) => {
        this.cantClientes = res.length;
        this.cdr.detectChanges();
      },
      error: (err) => console.error('Error al obtener clientes:', err)
    });

    // Proyectos
    this.apiService.obtenerProyectos().subscribe({
      next: (res: any[]) => {
        this.cantObras = res.length;
        
        // Contar por estados para la gráfica de pie
        const construccion = res.filter(p => p.estado === 'En construcción').length;
        const planificacion = res.filter(p => p.estado === 'En planificación' || p.estado === 'Planificación').length;
        const finalizado = res.filter(p => p.estado === 'Finalizado' || p.estado === 'Finalizados').length;
        
        this.pieChartData = {
          labels: ['En construcción', 'Planificación', 'Finalizados'],
          datasets: [{
            data: [construccion, planificacion, finalizado]
          }]
        };
        this.cdr.detectChanges();
      },
      error: (err) => console.error('Error al obtener proyectos:', err)
    });

    // Ventas
    this.apiService.obtenerVentas().subscribe({
      next: (res: any[]) => {
        this.totalVentas = res.reduce((acc, curr) => acc + Number(curr.total || 0), 0);
        
        // Llenar datos de ventas de forma simplificada en el gráfico lineal si hay ventas
        const ventasPorMes = [0, 0, 0, 0, 0, 0]; // Ene, Feb, Mar, Abr, May, Jun
        res.forEach(v => {
          if (v.fecha) {
            const mes = new Date(v.fecha).getMonth();
            if (mes >= 0 && mes < 6) {
              ventasPorMes[mes] += Number(v.total || 0);
            }
          }
        });
        
        const hayVentas = ventasPorMes.some(v => v > 0);
        if (!hayVentas && this.totalVentas > 0) {
          const mesActual = new Date().getMonth();
          if (mesActual >= 0 && mesActual < 6) {
            ventasPorMes[mesActual] = this.totalVentas;
          } else {
            ventasPorMes[5] = this.totalVentas; // Junio por defecto
          }
        }

        this.lineChartData = {
          labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'],
          datasets: [
            {
              data: ventasPorMes,
              label: 'Ventas',
              tension: 0.4
            }
          ]
        };
        this.cdr.detectChanges();
      },
      error: (err) => console.error('Error al obtener ventas:', err)
    });
  }

}