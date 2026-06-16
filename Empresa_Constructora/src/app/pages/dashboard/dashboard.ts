import { Component, OnInit } from '@angular/core';

import { CommonModule } from '@angular/common';

import {
  Router,
  RouterModule,
  RouterOutlet
} from '@angular/router';



@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    RouterOutlet
  ],
  templateUrl: './dashboard.html',
  styleUrl: './dashboard.scss'
})
export class DashboardComponent implements OnInit {

  esAdminGeneral = false;
  nombreEmpresa = '';

  constructor(
    private router: Router
  ){}

  ngOnInit() {
    const empresaDataStr = localStorage.getItem('empresa');
    if (empresaDataStr) {
      try {
        const empresaData = JSON.parse(empresaDataStr);
        this.nombreEmpresa = empresaData.nombre_empresa || '';
      } catch (e) {}
    }

    const usuarioStr = localStorage.getItem('usuario');
    if (usuarioStr) {
      try {
        const usuario = JSON.parse(usuarioStr);
        if (usuario && usuario.rol === 'Administrador') {
          this.esAdminGeneral = true;
          this.nombreEmpresa = 'Administrador General';
        }
      } catch (e) {
        console.error('Error parsing usuario from localStorage:', e);
      }
    }
  }

  // ===== GRAFICA LINEAL =====

  lineChartData = {
    labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'],
    datasets: [
      {
        data: [650000, 720000, 860000, 780000, 940000, 860000],
        label: 'Ventas',
        tension: 0.4
      }
    ]
  };

  lineChartType: any = 'line';

  // ===== GRAFICA PIE =====

  pieChartData = {
    labels: [
      'En construcción',
      'Planificación',
      'Finalizados'
    ],
    datasets: [
      {
        data: [15, 8, 5]
      }
    ]
  };

  pieChartType: any = 'pie';

  // ===== CERRAR SESION =====

  cerrarSesion(){

    localStorage.removeItem('empresa');
    localStorage.removeItem('usuario');

    this.router.navigate(['/login']);

  }

}