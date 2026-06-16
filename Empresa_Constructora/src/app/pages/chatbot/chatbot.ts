import { Component, ViewChild, ElementRef, AfterViewChecked, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { ApiService } from '../../services/api';

@Component({
  selector: 'app-chatbot',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './chatbot.html',
  styleUrl: './chatbot.scss'
})
export class ChatbotComponent implements AfterViewChecked {

  @ViewChild('chatBox') chatBox!: ElementRef;

  pregunta = '';

  mensajes: any[] = [];

  cargando = false;

  mediaRecorder!: MediaRecorder;

  audioChunks: Blob[] = [];

  private debeScrool = false;

  constructor(
    private api: ApiService,
    private cdr: ChangeDetectorRef
  ){}

  ngAfterViewChecked(){
    if(this.debeScrool){
      this.scrollAlFinal();
      this.debeScrool = false;
    }
  }

  scrollAlFinal(){
    try {
      if(this.chatBox){
        this.chatBox.nativeElement.scrollTop =
          this.chatBox.nativeElement.scrollHeight;
      }
    } catch(e){}
  }

  private obtenerMensajeError(err: any): string {
    if(err.name === 'TimeoutError'){
      return 'La IA tardó demasiado en responder. Por favor intenta de nuevo.';
    }
    if(err?.error?.detail){
      return 'Error de IA: ' + err.error.detail;
    }
    if(err.status === 0){
      return 'No se pudo conectar con el servidor. Verifica que el backend esté corriendo.';
    }
    return 'Error al conectar con la IA. Intenta de nuevo.';
  }

  enviarPregunta(){

    if(!this.pregunta.trim() || this.cargando) return;

    const texto = this.pregunta;

    this.mensajes.push({
      tipo: 'usuario',
      texto: texto
    });

    this.pregunta = '';

    this.cargando = true;
    this.debeScrool = true;

    console.log('Enviando pregunta a la IA:', texto);
    console.log('Headers de la petición:', (this.api as any).getHeaders());

    this.api.preguntarIA(texto)
    .subscribe({

      next: (resp:any) => {
        console.log('Respuesta recibida exitosamente:', resp);

        this.mensajes.push({
          tipo: 'ia',
          texto: resp.respuesta || 'La IA no generó respuesta.'
        });

        this.cargando = false;
        this.debeScrool = true;
        this.cdr.detectChanges();

      },

      error: (err) => {
        console.error('Error al consultar la IA:', err);

        this.mensajes.push({
          tipo: 'ia',
          texto: this.obtenerMensajeError(err)
        });

        this.cargando = false;
        this.debeScrool = true;
        this.cdr.detectChanges();

      }

    });

  }

  async iniciarGrabacion(){

    const stream =
      await navigator.mediaDevices.getUserMedia({
        audio: true
      });

    this.mediaRecorder =
      new MediaRecorder(stream);

    this.audioChunks = [];

    this.mediaRecorder.ondataavailable =
      (event:any) => {

      this.audioChunks.push(event.data);

    };

    this.mediaRecorder.start();

    alert('Grabando audio...');

  }

  detenerGrabacion(){

    this.mediaRecorder.stop();

    this.mediaRecorder.onstop = () => {

      const audioBlob = new Blob(
        this.audioChunks,
        {
          type: 'audio/webm'
        }
      );

      const formData = new FormData();

      formData.append(
        'audio',
        audioBlob,
        'audio.webm'
      );

      this.cargando = true;
      this.debeScrool = true;

      this.mensajes.push({
        tipo: 'usuario',
        texto: '🎤 Audio enviado'
      });

      this.api.preguntarAudio(formData)
      .subscribe({

        next: (resp:any) => {

          console.log(resp);

          this.mensajes.push({
            tipo: 'ia',
            texto: resp.respuesta
          });

          this.cargando = false;
          this.debeScrool = true;
          this.cdr.detectChanges();

        },

        error: (err) => {

          console.error('Error Audio IA:', err);

          this.mensajes.push({
            tipo: 'ia',
            texto: this.obtenerMensajeError(err)
          });

          this.cargando = false;
          this.debeScrool = true;
          this.cdr.detectChanges();

        }

      });

    };

  }

}