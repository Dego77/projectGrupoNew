import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_constructora/theme/app_theme.dart';
import 'package:app_constructora/providers/user_provider.dart';

class MyProjectScreen extends StatefulWidget {
  const MyProjectScreen({super.key});

  @override
  State<MyProjectScreen> createState() => _MyProjectScreenState();
}

class _MyProjectScreenState extends State<MyProjectScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().cargarProyectoYPagos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final double _progress = userProvider.globalProgress;
    final proyecto = userProvider.proyectoRealData;

    if (!userProvider.hasActiveProject) {
      // Estado vacío
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mi Obra'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Actualizar',
              onPressed: () => context.read<UserProvider>().cargarProyectoYPagos(),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => context.read<UserProvider>().cargarProyectoYPagos(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.maps_home_work_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 24),
                      Text('Aún no tienes una obra en curso.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      SizedBox(height: 8),
                      Text('Solicita tu presupuesto para comenzar.', style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final String estadoProyecto = userProvider.proyectoRealData?['estado'] ?? '';

    if (estadoProyecto == 'Pendiente') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mi Obra'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Actualizar',
              onPressed: () => context.read<UserProvider>().cargarProyectoYPagos(),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => context.read<UserProvider>().cargarProyectoYPagos(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Selector de proyecto si tiene más de uno
                if (userProvider.misProyectosReales.length > 1) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.swap_horiz, color: AppTheme.primaryColor),
                        const SizedBox(width: 12),
                        const Text(
                          'Proyecto: ',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: userProvider.idProyectoSeleccionado,
                              isExpanded: true,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),
                              items: userProvider.misProyectosReales.map((p) {
                                return DropdownMenuItem<int>(
                                  value: p['id_proyecto'],
                                  child: Text(p['nombre'] ?? 'Proyecto'),
                                );
                              }).toList(),
                              onChanged: (id) {
                                if (id != null) {
                                  userProvider.seleccionarProyecto(id);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.rate_review_outlined, size: 80, color: Colors.amber.shade800),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Proyecto en Evaluación',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'La constructora está revisando la propuesta de tu obra. Una vez aprobada y en planificación, comenzaremos con los preparativos y podrás ver la línea de tiempo, los recursos asignados y los reportes de avance.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => context.read<UserProvider>().cargarProyectoYPagos(),
                  icon: const Icon(Icons.sync),
                  label: const Text('Actualizar Estado'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Estado con proyecto activo
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Obra'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: () => context.read<UserProvider>().cargarProyectoYPagos(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<UserProvider>().cargarProyectoYPagos(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de proyecto si tiene más de uno
              if (userProvider.misProyectosReales.length > 1) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.swap_horiz, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      const Text(
                        'Proyecto: ',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: userProvider.idProyectoSeleccionado,
                            isExpanded: true,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),
                            items: userProvider.misProyectosReales.map((p) {
                              return DropdownMenuItem<int>(
                                value: p['id_proyecto'],
                                child: Text(p['nombre'] ?? 'Proyecto'),
                              );
                            }).toList(),
                            onChanged: (id) {
                              if (id != null) {
                                userProvider.seleccionarProyecto(id);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // PROGRESO DE LA OBRA (ESTÁTICO PARA CLIENTE) ----
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50, 
                  borderRadius: BorderRadius.circular(12), 
                  border: Border.all(color: Colors.red.shade200)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progreso de la Obra', 
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)
                        ),
                        Text(
                          '${_progress.toInt()}%',
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double maxWidth = constraints.maxWidth;
                        final double dotPosition = (maxWidth * (_progress / 100.0)).clamp(0.0, maxWidth);
                        
                        return Stack(
                          alignment: Alignment.centerLeft,
                          clipBehavior: Clip.none,
                          children: [
                            // Background track
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            // Active progress track
                            Container(
                              height: 6,
                              width: dotPosition,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            // Red dot at the end
                            Positioned(
                              left: dotPosition - 10,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // ---------------------------
  
              Text('Recursos en Sitio', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _buildPersonCard(
                context,
                proyecto?['nom_ingeniero'] ?? 'No asignado',
                'Director de Proyecto',
              ),
              const SizedBox(height: 12),
              _buildPersonCard(
                context,
                proyecto?['nom_residente'] ?? 'No asignado',
                'Residente de Obras',
              ),
              const SizedBox(height: 12),
              _buildPersonCard(
                context,
                proyecto?['nom_maestro'] ?? 'No asignado',
                'Maestro de Obra',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildResourceStat(
                      Icons.engineering,
                      '${proyecto?['cant_obreros'] ?? 0}',
                      'Obreros activos',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildResourceStat(
                      Icons.fire_truck_outlined,
                      '0',
                      'Maquinaria',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              Text('Documentos del Proyecto', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDocCard(context, Icons.picture_as_pdf, 'Planos Arquitectónicos', 'Ver PDF'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDocCard(context, Icons.view_in_ar, 'Boceto 3D y Renders', 'Ver Galería'),
                  ),
                ],
              ),
  
              const SizedBox(height: 32),
              Text('Línea de Tiempo', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              
              // Fases dependientes de _progress
              // Fase 1: Cimientos (0 - 33)
              _buildDynamicTimelineNode(
                context, 
                _progress,
                title: 'Cimientos y Estructura Base', 
                startThreshold: 0, 
                endThreshold: 33, 
                isLast: false
              ),
              
              // Fase 2: Obra Gruesa (34 - 66)
              _buildDynamicTimelineNode(
                context, 
                _progress,
                title: 'Mampostería y Obra Gruesa', 
                startThreshold: 34, 
                endThreshold: 66, 
                isLast: false
              ),
              
              // Fase 3: Acabados (67 - 100)
              _buildDynamicTimelineNode(
                context, 
                _progress,
                title: 'Acabados, Pintura y Entrega', 
                startThreshold: 67, 
                endThreshold: 100, 
                isLast: true
              ),
              const SizedBox(height: 32),
              Text('Galería de Avances', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _buildGallery(_progress),
              _buildProjectDetailsCard(context, userProvider),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectDetailsCard(BuildContext context, UserProvider userProvider) {
    final proyecto = userProvider.proyectoRealData;
    final cotizacion = userProvider.cotizacionProyectoReal;

    if (proyecto == null) return const SizedBox.shrink();

    final String ubicacion = proyecto['ubicacion'] ?? 'Ubicación no especificada';
    final String estado = proyecto['estado'] ?? 'Pendiente';

    final String m2 = cotizacion != null ? '${cotizacion['m2_construir']} M²' : '120 M²';
    final String calidad = cotizacion != null ? 'Materiales ${cotizacion['calidad_materiales']}' : 'Materiales Lujo';
    final String habitaciones = cotizacion != null ? '${cotizacion['habitaciones']}' : '3';
    final String banos = cotizacion != null ? '${cotizacion['banos']}' : '2';
    
    String ambientes = 'Salas integradas, Jardín';
    if (cotizacion != null && cotizacion['ambientes'] != null) {
      if (cotizacion['ambientes'] is List) {
        ambientes = (cotizacion['ambientes'] as List).join(', ');
      } else if (cotizacion['ambientes'] is String) {
        ambientes = cotizacion['ambientes'];
      }
    }

    Color estadoColor = Colors.orange;
    Color estadoBgColor = Colors.orange.shade100;
    if (estado == 'Aprobado' || estado == 'En curso') {
      estadoColor = Colors.green;
      estadoBgColor = Colors.green.shade100;
    } else if (estado == 'Finalizado') {
      estadoColor = Colors.blue;
      estadoBgColor = Colors.blue.shade100;
    }

    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: estadoColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estado del Proyecto:', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: estadoBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  estado,
                  style: TextStyle(color: estadoColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Ubicación del Proyecto:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(ubicacion, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 16),
          const Text('Detalles de Construcción:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          Text(
            '• $m2 de Construcción\n'
            '• $calidad\n'
            '• $habitaciones Cuartos, $banos Baños\n'
            '• $ambientes',
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
          const Divider(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Acordado:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '\$${userProvider.budgetTotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Descargando contrato PDF...')),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Descargar Contrato PDF'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceStat(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))]),
      child: Column(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildDocCard(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blueGrey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppTheme.primaryColor)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildPersonCard(BuildContext context, String name, String role) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          const CircleAvatar(radius: 30, backgroundColor: AppTheme.backgroundColor, child: Icon(Icons.person, size: 30, color: AppTheme.secondaryColor)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(role, style: const TextStyle(color: AppTheme.textSecondaryColor)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.primaryColor), onPressed: () {})
        ],
      ),
    );
  }

  Widget _buildDynamicTimelineNode(BuildContext context, double _progress, {required String title, required int startThreshold, required int endThreshold, required bool isLast}) {
    bool isPast = _progress > endThreshold;
    bool isCurrent = _progress >= startThreshold && _progress <= endThreshold;
    
    // Si la progresión es menor a 0 en casos raros
    if (_progress == 100 && startThreshold == 67) {
       isPast = true;
       isCurrent = false; // El último se marca completado si estamos a 100%
    }

    String dateStr = 'Pendiente';
    if (isPast) dateStr = 'Completado';
    if (isCurrent) dateStr = 'En curso (${_progress.toInt()}%)';
    if (_progress == 100 && startThreshold >= 67) dateStr = 'Proyecto Finalizado';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20, height: 20, 
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: isPast ? AppTheme.primaryColor : (isCurrent ? Colors.orange : Colors.grey.shade300), 
                border: isCurrent ? Border.all(color: Colors.orange.shade200, width: 4) : null
              )
            ),
            if (!isLast) Container(width: 2, height: 50, color: isPast ? AppTheme.primaryColor : Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(title, style: TextStyle(fontSize: 16, fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500, color: isCurrent ? Colors.black87 : (isPast ? Colors.black87 : Colors.grey))),
               const SizedBox(height: 4),
               Text(dateStr, style: TextStyle(fontSize: 13, color: isCurrent ? Colors.orange.shade800 : AppTheme.textSecondaryColor)),
               const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGallery(double _progress) {
    // Definimos cuántas fotos hay basadas en la fase
    int photosCount = 2; // Cimientos
    if (_progress > 33) photosCount = 4; // Obra Gruesa
    if (_progress > 66) photosCount = 6; // Acabados

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2),
      itemCount: photosCount,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Colors.grey.shade300,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Icon(Icons.construction, size: 40, color: Colors.grey.shade500),
                Positioned(bottom: 0, left: 0, right: 0, child: Container(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), color: Colors.black54, child: Text('Avance ${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)))),
              ],
            ),
          ),
        );
      },
    );
  }
}
