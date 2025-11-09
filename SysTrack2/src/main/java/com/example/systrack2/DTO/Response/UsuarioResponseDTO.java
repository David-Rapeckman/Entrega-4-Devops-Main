package com.example.systrack2.DTO.Response;

import lombok.Data;

@Data
public class UsuarioResponseDTO {
    private Long id;
    private String nome;
    private String email;
    private String role;
}
